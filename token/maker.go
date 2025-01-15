package token

import "time"

// Maker is an interface that defines the methods a token maker type must provide
type Maker interface {
	CreateToken(username string, duration time.Duration) (string, *Payload, error)

	VerifyToken(token string) (*Payload, error)
}
