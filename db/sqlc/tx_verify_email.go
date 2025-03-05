package db

import "context"

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

		return err
	})

	return result, err
}
