package gapi

import (
	"context"
	"errors"

	db "github.com/aspandyar/simple-bank/db/sqlc"
	"github.com/aspandyar/simple-bank/pb"
	"github.com/aspandyar/simple-bank/util"
	"github.com/lib/pq"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (server *Server) CreateUser(ctx context.Context, req *pb.CreateUserRequest) (*pb.CreateUserResponse, error) {
	hashedPassword, err := util.HashPassword(req.GetPassword())
	if err != nil {
		return nil, status.Errorf(codes.Internal, "cannot hash password: %s", err)
	}

	arg := db.CreateUserParams{
		Username:       req.GetUsername(),
		HashedPassword: hashedPassword,
		FullName:       req.GetFullName(),
		Email:          req.GetEmail(),
	}

	user, err := server.store.CreateUser(ctx, arg)
	if err != nil {
		var pqErr *pq.Error
		if errors.As(err, &pqErr) {
			switch pqErr.Code.Name() {
			case "unique_violation":
				return nil, status.Error(codes.AlreadyExists, "username or email already exists")
			}
		}

		return nil, status.Errorf(codes.Internal, "cannot create user: %s", err)
	}

	rsp := &pb.CreateUserResponse{
		User: converUser(user),
	}

	return rsp, nil
}
