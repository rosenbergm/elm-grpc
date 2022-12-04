package main

import (
	"grpc_test/protos"

	"log"
	"net"

	"google.golang.org/grpc"
)

func main() {
	println("elm-grpc Go gRPC-web server")

	lis, err := net.Listen("tcp", ":9000")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	protos.RegisterPingServiceServer(s, &protos.Server{})
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
