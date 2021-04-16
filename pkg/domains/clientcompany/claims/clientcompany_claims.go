package clientcompany_claims

import (
	mycompany "github.com/celsosantos/edge-proxy/pkg/domains/mycompany/claims"
)

// ClientClaims represents a client token
type ClientClaims struct {}

// Valid checks if the token is valid by assessing its expiration
func (claims ClientClaims) Valid() error {
	return nil //always valid
}

// ToCompanyJwt creates a MyCompanyJWT from ClientClaims
func (claims *ClientClaims) ToMyCompanyJwt() (string, error) {
	mycompanyClaims := mycompany.MyCompanyClaims{}
	return mycompanyClaims.CreateToken(
		"userID",
		"UserFullName",
		"UserEmail",
		"UserPhoneNumber",
		"1",
		"originalToken",
		[]string{"ROLE_A", "ROLE_B"},
		"UTC", //TODO: Find a way to get this from the system
	)
}
