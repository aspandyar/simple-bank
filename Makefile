postgres:
	@echo -e "\033[1;34mStarting PostgreSQL container...\033[0m"
	@if docker run --name simple-bank-postgres -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=qwerty123 -d postgres:latest; then \
	    echo -e "\033[1;32mPostgreSQL container started successfully.\033[0m"; \
	else \
	    echo -e "\033[1;31mFailed to start PostgreSQL container. Attempting to remove existing container...\033[0m"; \
	    read -p "Are you sure you want to remove the existing PostgreSQL container and start a new one? [y/N] " answer && \
	    if [ "$$answer" = "y" ]; then \
	        docker rm -f simple-bank-postgres && \
	        docker run --name simple-bank-postgres -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=qwerty123 -d postgres:latest && \
	        echo -e "\033[1;32mPostgreSQL container started successfully after removal.\033[0m" || \
	        (echo -e "\033[1;31mFailed to start PostgreSQL container even after removal.\033[0m" && exit 1); \
	    else \
	        echo -e "\033[1;31mOperation canceled by user.\033[0m" && exit 1; \
	    fi \
	fi

postgresdown:
	@echo -e "\033[1;34mStopping PostgreSQL container...\033[0m"
	@if docker stop simple-bank-postgres; then \
	    echo -e "\033[1;32mPostgreSQL container stopped successfully.\033[0m"; \
	else \
	    echo -e "\033[1;31mFailed to stop PostgreSQL container.\033[0m" && exit 1; \
	fi

createdb:
	@echo -e "\033[1;34mCreating database...\033[0m"
	@if docker exec -it simple-bank-postgres createdb --username=root --owner=root simple_bank; then \
	    echo -e "\033[1;32mDatabase created successfully.\033[0m"; \
	else \
	    echo -e "\033[1;31mFailed to create database.\033[0m"; \
	    exit 1; \
	fi

dropdb:
	@echo -e "\033[1;34mDropping database...\033[0m"
	@read -p "Are you sure you want to drop the database simple_bank? [y/N] " answer && \
	if [ "$$answer" = "y" ]; then \
		if docker exec -it simple-bank-postgres dropdb simple_bank; then \
			echo -e "\033[1;32mDatabase dropped successfully.\033[0m"; \
		else \
			echo -e "\033[1;31mFailed to drop database.\033[0m" && exit 1; \
		fi \
	else \
		echo -e "\033[1;31mOperation canceled by user.\033[0m" && exit 1; \
	fi


migrateup:
	@echo -e "\033[1;34mMigrating up...\033[0m"
	@if migrate -path db/migration -database "postgresql://root:qwerty123@localhost:5432/simple_bank?sslmode=disable" -verbose up; then \
	    echo -e "\033[1;32mMigrated up successfully.\033[0m"; \
	else \
	    echo -e "\033[1;31mMigration up failed.\033[0m" && exit 1; \
	fi

migratedown:
	@echo -e "\033[1;34mMigrating down...\033[0m"
	@read -p "Are you sure you want to migrate down? This action will apply down migrations. [y/N] " answer && \
	if [ "$$answer" = "y" ]; then \
	    if migrate -path db/migration -database "postgresql://root:qwerty123@localhost:5432/simple_bank?sslmode=disable" -verbose down; then \
	        echo -e "\033[1;32mMigrated down successfully.\033[0m"; \
	    else \
	        echo -e "\033[1;31mMigration down failed.\033[0m" && exit 1; \
	    fi \
	else \
	    echo -e "\033[1;31mOperation canceled by user.\033[0m" && exit 1; \
	fi

.PHONY: postgres createdb dropdb migrateup migratedown