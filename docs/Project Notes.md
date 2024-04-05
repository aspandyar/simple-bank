## Navigation

- [Application](#application)
- [Database](#database)
- [Docker](#docker)
- [Migration](#migration)
- [CRUD](#crud)
- [Unit Test](#unit-test)
- [Transaction](#transaction)


## Application

### Application we will build:

#### A simple bank:

+ Create and manage account
	+ Owner, balance, currency
+ Record all balance changes
	+ Create an account entry for each change
+ Money transfer transaction
	+ Perform money transfer between 2 accounts consistently withing transaction


## Database

#### Database Design:

+ Design DB schema
	+ Design a SQL DB schema using **[dbdiagram.io](https://dbdiagram.io)**
+ Save & share DB diagram
	+ Save the DB schema as PDF/PNG diagram and share it with your team
+ Generate SQL code
	+ Generating code to create the schema in a target database engine: Postgres/MySQL/SQL Server

#### ERD diagram:

![[Simple Bank.png|]]


## Docker

### Manual to [[Docker]]

###  I used a [docker hub](https://hub.docker.com/) to download image of container to PostgresSQL.

### *Alpine* images are images, which size are very small, so I use it.

#### Creating image

```bash
docker pull postgres:12-alpine
```

#### Running a container (first time)

```bash
docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=qwerty123 -d postgres:12-alpine 
```

#### Exec container


```bash
docker exec -it postgres12 psql -U root
```

	psql => type of running command (it also can be bash, mongosh, /bin/sh, and etc.)

- -u, --user string          Username or UID (format: "<name|uid>[:<group|gid>]")


## Migration

### [[migration.canvas|migration]] will be in [golang library](https://github.com/golang-migrate/migrate)


See how to download it in [[Uncompress .tar.gz files]]

### Creating migration

```bash
migrate create -ext sql -dir db/migration -seq init_schema
```

### Basic commands from migration:

```bash
$ migrate create --help

create [-ext E] [-dir D] [-seq] [-digits N] [-format] [-tz] NAME
	   Create a set of timestamped up/down migrations titled NAME, in directory D with extension E.
	   Use -seq option to generate sequential up/down migrations with N digits.
	   Use -format option to specify a Go time format string. Note: migrations with the same time cause "duplicate migration version" error.
           Use -tz option to specify the timezone that will be used when generating non-sequential migrations (defaults: UTC).

  -digits int
    	The number of digits to use in sequences (default: 6) (default 6)
  -dir string
    	Directory to place file in (default: current working directory)
  -ext string
    	File extension
  -format string
    	The Go time format string to use. If the string "unix" or "unixNano" is specified, then the seconds or nanoseconds since January 1, 1970 UTC respectively will be used. Caution, due to the behavior of time.Time.Format(), invalid format strings will not error (default "20060102150405")
  -help
    	Print help information
  -seq
    	Use sequential numbers instead of timestamps (default: false)
  -tz string
    	The timezone that will be used for generating timestamps (default: utc) (default "UTC")
```

### Following scripts to organise migration easily:

```make
postgres:  
    docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=qwerty123 -d postgres:12-alpine  
  
createdb:  
    docker exec -it postgres12 createdb --username=root --owner=root simple_bank  
  
dropdb:  
    docker exec -it postgres12 dropdb --username=root simple_bank  
  
migrateup:  
    migrate -path db/migration -database "postgresql://root:qwerty123@localhost:5432/simple_bank?sslmode=disable" -verbose up  
  
migratedown:  
    migrate -path db/migration -database "postgresql://root:qwerty123@localhost:5432/simple_bank?sslmode=disable" -verbose down  
  
.PHONY: postgres createdb dropdb migrateup migratedown
```

To apply migration, we should to set up database in psql (PostgreSQL), so createdb do it, and applying migrateup

## CRUD

**note**: see [[CRUD]] to learn more about it

### I use [sqlc](https://github.com/sqlc-dev/sqlc) to generate CRUD code in our project.

-  `sqlc init` => to init directory
- write `sqlc.yaml` file configuration, in my case I used a 2nd version of code:

```yaml
version: "2"  
sql:  
    - engine: "postgresql"  
      queries: "./db/query/"  
      schema: "./db/migration/"  
      gen:  
          go:  
              package: "db"  
              out: "db/sqlc"  
              sql_package: "database/sql"
```

- `Package` required name of package which will be set up all generating files
- `Out` is path where it should generate it

- Also I created a directory `./db/query/account.sql`, and insert a generation code from docs:

```sql
-- name: GetAccount :one  
SELECT * FROM accounts  
WHERE id = $1 LIMIT 1;  
  
-- name: ListAccount :many  
SELECT * FROM accounts  
ORDER BY owner;  
  
-- name: CreateAccount :one  
INSERT INTO accounts (  
    owner, balance, currency  
) VALUES (  
             $1, $2, $3  
         )  
RETURNING *;  
  
-- name: UpdateAccount :exec  
UPDATE accounts  
set balance = $2,  
    currency = $3  
WHERE id = $1;  
  
-- name: DeleteAccount :exec  
DELETE FROM accounts  
WHERE id = $1;
```

- After it, execute command: `sqlc generate` to generate CRUD function to account table.

## Unit Test

### By applying unit test in golang, we should to import postgres driver, in that cases used a [pq](https://github.com/lib/pq) golang lib

To check testing result it would be easier to use [testify](https://github.com/stretchr/testify) lib, instead of writing by own.

[see unit tests in repo](https://github.com/aspandyar/simple-bank/tree/master/db/sqlc) and some [[Unit Test (GO)]] notes

## Transaction

**notes:** [[Transaction]]

