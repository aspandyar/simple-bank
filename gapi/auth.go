package gapi

import (
	"context"
	"fmt"
	"strings"

	"github.com/aspandyar/simple-bank/token"
	"google.golang.org/grpc/metadata"
)

const (
	authorizationHeader = "authorization"
)

func (server *Server) authUser(ctx context.Context) (*token.Payload, error) {
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return nil, fmt.Errorf("metadata is not provided")
	}

	values := md.Get(authorizationHeader)
	if len(values) == 0 {
		return nil, fmt.Errorf("authorization token is not provided")
	}

	authHeader := values[0]
	// bearer token <authorization-type> <authorization-value>
	fileds := strings.Fields(authHeader)
	if len(fileds) != 2 {
		return nil, fmt.Errorf("authorization token is invalid")
	}

	authType := strings.ToLower(fileds[0])
	if authType != "bearer" {
		return nil, fmt.Errorf("authorization type is not supported")
	}

	accessToken := fileds[1]
	payload, err := server.tokenMaker.VerifyToken(accessToken)
	if err != nil {
		return nil, fmt.Errorf("cannot verify token: %w", err)
	}

	return payload, nil
}
