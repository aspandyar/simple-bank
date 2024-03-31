
## Navigation

- [Application](#application)
- [Database](#database)
- [Docker](#docker)
- [Migration](#migration)

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

### Migration will be in [golang library](https://github.com/golang-migrate/migrate)


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

To apply migration, we should to set up database in psql (PostgreSQL), so createdb do it, and applying migrate up and down