package db

import "database/sql"

type Store struct {
	*Queries
	db *pgx.
}

func NewStore(db *sql.DB) *Store {
	return &Store{
		db:      db,
		Queries: New(db),
	}
}
