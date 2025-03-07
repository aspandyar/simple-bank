package db

import (
	"context"

	"github.com/jackc/pgx/v5/pgtype"
)

type VerifyEmailTXParams struct {
	EmailId    int64
	SecretCode string
}

type VerifyEmailTXResult struct {
	User        User
	VerifyEmail VerifyEmail
}

func (store *SQLStore) VerifyEmailTX(ctx context.Context, arg VerifyEmailTXParams) (VerifyEmailTXResult, error) {
	var result VerifyEmailTXResult

	err := store.execTx(ctx, func(queries *Queries) error {
		var err error

		result.VerifyEmail, err = queries.UpdateVerifyEmail(ctx, UpdateVerifyEmailParams{
			ID:         arg.EmailId,
			SecretCode: arg.SecretCode,
		})
		if err != nil {
			return err
		}

		result.User, err = queries.UpdateUser(ctx, UpdateUserParams{
			Username: result.VerifyEmail.Username,
			IsEmailVerified: pgtype.Bool{
				Bool:  true,
				Valid: true,
			},
		})

		return err
	})

	return result, err
}
