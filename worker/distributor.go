package worker

import (
	"context"

	"github.com/hibiken/asynq"
)

type TaskDistribution interface {
	DistributeTaskSendVerifyEmail(ctx context.Context, payload *PayloadSendVerifyEmail, opts ...asynq.Option) error
}

type RedisTaskDistribution struct {
	client *asynq.Client
}

func NewRedisTaskDistribution(redisOpt asynq.RedisClientOpt) TaskDistribution {
	client := asynq.NewClient(redisOpt)
	return &RedisTaskDistribution{
		client: client,
	}
}
