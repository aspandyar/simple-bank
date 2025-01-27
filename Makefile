COLOR_RESET=\033[0m
COLOR_BOLD=\033[1m
COLOR_GREEN=\033[1;32m
COLOR_RED=\033[1;31m
COLOR_BLUE=\033[1;34m

DB_URL := postgresql://root:qwerty123@localhost:5432/simple_bank?sslmode=disable
MIGRATION_PATH := db/migration

postgres:
	@echo -e "$(COLOR_BLUE)Starting PostgreSQL container...$(COLOR_RESET)"
	@if docker run -d --name simple-bank-postgres --network simple-bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=qwerty123 -d postgres:latest; then \
	    echo -e "$(COLOR_GREEN)PostgreSQL container started successfully.$(COLOR_RESET)"; \
	else \
	    echo -e "$(COLOR_RED)Failed to start PostgreSQL container. Attempting to remove existing container...$(COLOR_RESET)"; \
	    read -p "Are you sure you want to remove the existing PostgreSQL container and start a new one? [y/N] " answer && \
	    if [ "$$answer" = "y" ]; then \
	        docker rm -f simple-bank-postgres && \
	        docker run -d --name simple-bank-postgres --network simple-bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=qwerty123 -d postgres:latest && \
	        echo -e "$(COLOR_GREEN)PostgreSQL container started successfully after removal.$(COLOR_RESET)" || \
	        (echo -e "$(COLOR_RED)Failed to start PostgreSQL container, you have no image named: postgres. Use: docker pull postgres.$(COLOR_RESET)" && exit 1); \
	    else \
	        echo -e "$(COLOR_RED)Operation canceled by user.$(COLOR_RESET)" && exit 1; \
	    fi \
	fi

postgresdown:
	@echo -e "$(COLOR_BLUE)Stopping PostgreSQL container...$(COLOR_RESET)"
	@if docker stop simple-bank-postgres; then \
	    echo -e "$(COLOR_GREEN)PostgreSQL container stopped successfully.$(COLOR_RESET)"; \
	else \
	    echo -e "$(COLOR_RED)Failed to stop PostgreSQL container.$(COLOR_RESET)" && exit 1; \
	fi

createdb:
	@echo -e "$(COLOR_BLUE)Creating database...$(COLOR_RESET)"
	@if docker exec -it simple-bank-postgres createdb --username=root --owner=root simple_bank; then \
	    echo -e "$(COLOR_GREEN)Database created successfully.$(COLOR_RESET)"; \
	else \
	    echo -e "$(COLOR_RED)Failed to create database.$(COLOR_RESET)"; \
	    exit 1; \
	fi

dropdb:
	@echo -e "$(COLOR_BLUE)Dropping database...$(COLOR_RESET)"
	@read -p "Are you sure you want to drop the database simple_bank? [y/N] " answer && \
	if [ "$$answer" = "y" ]; then \
		if docker exec -it simple-bank-postgres dropdb simple_bank; then \
			echo -e "$(COLOR_GREEN)Database dropped successfully.$(COLOR_RESET)"; \
		else \
			echo -e "$(COLOR_RED)Failed to drop database.$(COLOR_RESET)" && exit 1; \
		fi \
	else \
		echo -e "$(COLOR_RED)Operation canceled by user.$(COLOR_RESET)" && exit 1; \
	fi

migrateup:
	@echo -e "$(COLOR_BLUE)Migrating up all pending migrations...$(COLOR_RESET)"
	@if migrate -path $(MIGRATION_PATH) -database "$(DB_URL)" -verbose up; then \
	    echo -e "$(COLOR_GREEN)All migrations applied successfully.$(COLOR_RESET)"; \
	else \
	    echo -e "$(COLOR_RED)Migration failed.$(COLOR_RESET)" && exit 1; \
	fi

migrateup_steps:
	@if [ -z "$(steps)" ]; then \
	    echo -e "$(COLOR_RED)Error: 'steps' variable is not set. Usage: make migrateup_steps steps=<number>$(COLOR_RESET)"; \
	    exit 1; \
	else \
	    echo -e "$(COLOR_BLUE)Migrating up $(steps) step(s)...$(COLOR_RESET)"; \
	    if migrate -path $(MIGRATION_PATH) -database "$(DB_URL)" -verbose up $(steps); then \
	        echo -e "$(COLOR_GREEN)Migrated up $(steps) step(s) successfully.$(COLOR_RESET)"; \
	    else \
	        echo -e "$(COLOR_RED)Migration up failed.$(COLOR_RESET)" && exit 1; \
	    fi; \
	fi

migratedown:
	@echo -e "$(COLOR_BLUE)Rolling back all migrations...$(COLOR_RESET)"
	@if migrate -path $(MIGRATION_PATH) -database "$(DB_URL)" -verbose down; then \
	    echo -e "$(COLOR_GREEN)All migrations rolled back successfully.$(COLOR_RESET)"; \
	else \
	    echo -e "$(COLOR_RED)Rollback failed.$(COLOR_RESET)" && exit 1; \
	fi

migratedown_steps:
	@if [ -z "$(steps)" ]; then \
	    echo -e "$(COLOR_RED)Error: 'steps' variable is not set. Usage: make migratedown_steps steps=<number>$(COLOR_RESET)"; \
	    exit 1; \
	else \
	    echo -e "$(COLOR_BLUE)Migrating down $(steps) step(s)...$(COLOR_RESET)"; \
	    if migrate -path $(MIGRATION_PATH) -database "$(DB_URL)" -verbose down $(steps); then \
	        echo -e "$(COLOR_GREEN)Migrated down $(steps) step(s) successfully.$(COLOR_RESET)"; \
	    else \
	        echo -e "$(COLOR_RED)Migration down failed.$(COLOR_RESET)" && exit 1; \
	    fi; \
	fi

sqlc:
	@echo -e "$(COLOR_BLUE)Generating SQLC...$(COLOR_RESET)"
	@if sqlc generate; then \
	    echo -e "$(COLOR_GREEN)SQLC generated successfully.$(COLOR_RESET)"; \
	else \
	    echo -e "$(COLOR_RED)Failed to generate SQLC.$(COLOR_RESET)" && exit 1; \
	fi

db_docs:
	@echo -e "$(COLOR_BLUE)Building database documentation...$(COLOR_RESET)"
	@if dbdocs build docs/db.dbml; then \
	    echo -e "$(COLOR_GREEN)Database documentation built successfully.$(COLOR_RESET)"; \
	else \
	    echo -e "$(COLOR_RED)Failed to build database documentation.$(COLOR_RESET)" && exit 1; \
	fi

db_schema:
	@echo -e "$(COLOR_BLUE)Generating database schema...$(COLOR_RESET)"
	@if dbml2sql --postgres -o docs/schema.sql docs/db.dbml; then \
	    echo -e "$(COLOR_GREEN)Database schema generated successfully.$(COLOR_RESET)"; \
	else \
	    echo -e "$(COLOR_RED)Failed to generate database schema.$(COLOR_RESET)" && exit 1; \
	fi

test:
	@echo -e "$(COLOR_BLUE)Running tests...$(COLOR_RESET)"
	@if go test -v -cover ./...; then \
	    echo -e "$(COLOR_GREEN)Tests passed successfully.$(COLOR_RESET)"; \
	else \
	    echo -e "$(COLOR_RED)Tests failed.$(COLOR_RESET)" && exit 1; \
	fi

server:
	@echo -e "$(COLOR_BLUE)Starting server...$(COLOR_RESET)"
	@go run main.go

mock:
	@echo -e "$(COLOR_BLUE)Generating mocks...$(COLOR_RESET)"
	@mockgen -package mockdb -destination db/mock/store.go github.com/aspandyar/simple-bank/db/sqlc Store
	@echo -e "$(COLOR_GREEN)Mocks generated successfully.$(COLOR_RESET)"

proto:
	@echo -e "$(COLOR_BLUE)Generating protobuf...$(COLOR_RESET)"
	@rm -f pb/*.go
	@rm -f docs/swagger/*
	@protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
	--go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
	--openapiv2_out=docs/swagger --openapiv2_opt=allow_merge=true,merge_file_name=simple_bank \
	proto/*.proto
	@echo -e "$(COLOR_GREEN)Protobuf generated successfully.$(COLOR_RESET)"

evans:
	@echo -e "$(COLOR_BLUE)Starting Evans...$(COLOR_RESET)"
	@evans --host localhost --port 9090 -r repl
	@echo -e "$(COLOR_GREEN)Evans started successfully.$(COLOR_RESET)"


.PHONY: postgres createdb dropdb migrateup migratedown migrateup_steps migratedown_steps sqlc db_docs db_schema test server mock proto evans