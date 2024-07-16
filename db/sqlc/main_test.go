package db

import (
	"context"
	"github.com/jackc/pgx/v5"
	"log"
	"os"
	"testing"
)

const (
	dbSource = "postgresql://root:qwerty123@localhost:5432/simple_bank?sslmode=disable"
)

var testQueries *Queries

func TestMain(m *testing.M) {
	ctx := context.Background()

	pool, err := pgx.Connect(ctx, dbSource)
	if err != nil {
		log.Fatalf("Unable to connect to database: %v\n", err)
	}

	defer func(pool *pgx.Conn, ctx context.Context) {
		err := pool.Close(ctx)
		if err != nil {
			log.Fatalf("Unable to close database connection: %v\n", err)
		}
	}(pool, ctx)

	testQueries = New(pool)

	os.Exit(m.Run())
}
