package gapi

import (
	"fmt"

	db "github.com/aspandyar/simple-bank/db/sqlc"
	"github.com/aspandyar/simple-bank/pb"
	"github.com/aspandyar/simple-bank/token"
	"github.com/aspandyar/simple-bank/util"
	"github.com/aspandyar/simple-bank/worker"
)

// Server serves HTTP requests for the API.
type Server struct {
	pb.UnimplementedSimpleBankServer
	config          util.Config
	store           db.Store
	tokenMaker      token.Maker
	taskDistributor worker.TaskDistribution
}

// NewServer creates a new gRPC server and set up routing.
func NewServer(config util.Config, store db.Store, taskDistributor worker.TaskDistribution) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker %w", err)
	}

	server := &Server{
		config:          config,
		store:           store,
		tokenMaker:      tokenMaker,
		taskDistributor: taskDistributor,
	}

	return server, nil
}
