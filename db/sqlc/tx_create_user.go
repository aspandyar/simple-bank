package db

import "context"

type CreateUserTxParams struct {
	CreateUserParams
	AfterCreate func(user User) error
}

type CreateUserTXResult struct {
	User User
}

func (store *SQLStore) CreateUserTX(ctx context.Context, arg CreateUserTxParams) (CreateUserTXResult, error) {
	var result CreateUserTXResult

	err := store.execTx(ctx, func(queries *Queries) error {
		var err error

		result.User, err = queries.CreateUser(ctx, arg.CreateUserParams)
		if err != nil {
			return err
		}

		return arg.AfterCreate(result.User)
	})

	return result, err
}
