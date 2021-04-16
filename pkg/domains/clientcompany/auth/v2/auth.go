package client_auth_v2

import (
	"context"
	"fmt"

	api "github.com/celsosantos/edge-proxy/api/v2"
	clientcompany_claims "github.com/celsosantos/edge-proxy/pkg/domains/clientcompany/claims"
	envoyauthv2 "github.com/envoyproxy/go-control-plane/envoy/service/auth/v2"
)

type server struct{}

var _ envoyauthv2.AuthorizationServer = &server{}

// New creates a new authorization server.
func New() envoyauthv2.AuthorizationServer {
	return &server{}
}

// Check implements authorization's Check interface which performs authorization
// check based on the attributes associated with the incoming request.
func (s *server) Check(
	ctx context.Context,
	req *envoyauthv2.CheckRequest) (*envoyauthv2.CheckResponse, error) {
	
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
