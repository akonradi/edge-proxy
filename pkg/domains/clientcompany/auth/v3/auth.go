package client_auth_v3

import (
	"context"
	"fmt"

	api "github.com/celsosantos/edge-proxy/api/v3"
	clientcompany_claims "github.com/celsosantos/edge-proxy/pkg/domains/clientcompany/claims"
	envoyauthv3 "github.com/envoyproxy/go-control-plane/envoy/service/auth/v3"
)

type server struct{}

var _ envoyauthv3.AuthorizationServer = &server{}

// New creates a new authorization server.
func New() envoyauthv3.AuthorizationServer {
	return &server{}
}

// Check implements authorization's Check interface which performs authorization
// check based on the attributes associated with the incoming request.
func (s *server) Check(
	ctx context.Context,
	req *envoyauthv3.CheckRequest) (*envoyauthv3.CheckResponse, error) {
	
	user := &clientcompany_claims.ClientClaims{}
	
	if err := user.Valid(); err == nil {
		fmt.Println("Creating MyCompanyJWT...")
		mycompanyJwt, err := user.ToMyCompanyJwt()
		if err != nil {
			fmt.Println("Error creating MyCompanyJWT: ", err)
			return api.UnauthorizedResponse(), err
		}
		fmt.Println("MyCompanyJWT created!")

		fmt.Println("Allowing request...")
		return api.AuthorizedResponseWithToken(mycompanyJwt), nil
	} else if err != nil {
		fmt.Println("Error validating user: ", err)
		return api.UnauthorizedResponse(), err
	}

	fmt.Println("Denying request...")
	return api.UnauthorizedResponse(), nil
}
