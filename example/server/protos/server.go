package protos

import context "context"

type Server struct {
	UnimplementedPingServiceServer
}

func (s *Server) Ping(ctx context.Context, in *PingRequest) (*PongResponse, error) {
	resp := "Hello, " + in.GetName()
	return &PongResponse{Message: &resp}, nil
}
