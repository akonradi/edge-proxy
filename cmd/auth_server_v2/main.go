package main

import (
	"fmt"
	"log"
	"net"
	"os"
	"strconv"

	auth_v2 "github.com/celsosantos/edge-proxy/pkg/domains/clientcompany/auth/v2"
	envoy_service_auth_v2 "github.com/envoyproxy/go-control-plane/envoy/service/auth/v2"
	"google.golang.org/grpc"
)

func main() {

	port, err := strconv.Atoi(os.Getenv("SERVER_PORT"))
	if err != nil {
		log.Fatalf("failed to convert port number: %v", err)
	}

	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		log.Fatalf("failed to listen to %d: %v", port, err)
	}

	gs := grpc.NewServer()

	// Serve MyCompany v2
	envoy_service_auth_v2.RegisterAuthorizationServer(gs, auth_v2.New())

	log.Printf("starting gRPC server on: %d\n", port)
	gs.Serve(lis)
}
