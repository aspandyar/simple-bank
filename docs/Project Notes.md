
## Navigation

- [Application](#application)
- [Database](#database)
- [Docker](docker)

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

### I used a [docker hub](https://hub.docker.com/) to download image of container to PostgreSQL.

### *Alpine* images are images, which size are very small, so I use it.

```bash
docker pull postgres
```

### To start a container, here templates of code:

```bash
docker run --name <container_name> -e <env variable> -p <host_ports:container_ports> -d <image>:<tag>
```

#### Docker environment variables:

- `POSTGRES_PASSWORD` => set up **password** of PostgreSQL
- `POSTGRES_USER` => set up **user**, default user: ***postgres***
- `POSTGRES_DB` => set a default db, that created while *image first* started, default: `POSTGRES_USER` var will be used

#### Ports

`-p <host_ports:container_ports>`

**TODO**: Understand docker port! 5:28

### Command to that Project:

#### Creating image

```bash
docker pull postgres:12-alpine
```

#### Running a container (first time)

```bash

```