postgres:
	 docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=qwerty123 -d postgres:12-alpine

docker_start:
	docker start postgres12

docker_stop:
	docker stop postgres12

createdb:
	 docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migration_up:
	migrate -path db/migration/ -database "postgresql://root:qwerty123@localhost:5432/simple_bank?sslmode=disable" -verbose up

migration_down:
	migrate -path db/migration/ -database "postgresql://root:qwerty123@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	bin/sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb docker_start docker_stop migration_up migration_down sqlc test