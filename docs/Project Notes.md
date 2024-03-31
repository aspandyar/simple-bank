
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

### I used a [docker hub](https://hub.docker.com/) to download image of container to PostgresSQL.

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

	psql => type of running command (it also can be bash, mongosh, and etc.)

`-u, --user string          Username or UID (format: "<name|uid>[:<group|gid>]")`


## Migration

### Migration will be in [golang library](https://github.com/golang-migrate/migrate)


