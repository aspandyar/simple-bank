We will use PostgreSQL image, so go to [website](https://hub.docker.com/_/postgres) to see available images

### Getting Started

`alpine image => small image, which would be better for us, but I would use a full version of postgre`

To download a PostgreSQL image use `$ docker pull` command:

```bash
$ docker pull postgres
```


To see a list of docker image:

```bash
$ docker image ls
```

Output:

```bash
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
postgres     latest    f23dc7cd74bd   2 months ago   432MB
```

To start a docker container by image:

```bash
$ docker run --name <container_name> -e <env_variable> -p <host_ports:container_ports> -d <image>:<tag>
```

Output:

```bash
CONTAINER_ID
```

To see all containers:

```bash
$ docker ps -a
```

Output:

```bash
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS                     PORTS     NAMES
ff8dc769c6a4   postgres:latest   "docker-entrypoint.s…"   2 minutes ago   Exited (1) 2 minutes ago             postgres
```

If our container have following Error Status: `Exited (1)`, to see a logs, use following command:

```
$ docker logs <container_id_OR_name> 
```

To remove a container and image use following commands:

```bash
$ docker rm <container_id_OR_name>

$ docker image rm <image_id_OR_name>
```

### Example


Full command to start a docker container on port 5432, with setting up PostgreSQL by image inside:

```bash
$ docker run --name simple-bank-postgres -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=qwerty123 -d postgres:latest
```

Output:

```bash
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS         PORTS                                       NAMES
3ab36a84c22e   postgres:latest   "docker-entrypoint.s…"   4 seconds ago   Up 4 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   simple-bank-postgres
```

### Run Commands in Docker Container

To get into docker container use `docker exec` command:

```bash
docker exec -it <container_id_OR_name> <command> [args]
```

- `-i` or `--interactive` will Ensure that STDIN is opened if you have not attached it, and `-t` or `-tty` enables users to interact with the container's shell interactively
- psql => bash provided by PostgreSQL
- `-U` => (optional) user

Example:

```bash
$ docker exec -it simple-bank-posgres psql -U root
```

Output:

```bash
psql (16.3 (Debian 16.3-1.pgdg120+1))
Type "help" for help.

root=# 
```


**Note:** The PostgreSQL image sets up `trust` authentication locally so you may notice a password is not required when connecting from `localhost` (inside the same container). However, a password will be required if connecting from a different host/container.

### PostgreSQL Environment:

The PostgreSQL image uses several environment variables which are easy to miss. The ==only variable required== is `POSTGRES_PASSWORD`, the rest are **optional**.

##### 1. `POSTGRES_PASSWORD`

This environment variable is required for you to use the PostgreSQL image. It must not be empty or undefined. This environment variable sets the superuser password for PostgreSQL. The default superuser is defined by the `POSTGRES_USER` environment variable.

##### 2. `POSTGRES_USER`

This optional environment variable is used in conjunction with `POSTGRES_PASSWORD` to set a user and its password. This variable will create the specified user with superuser power and a database with the same name. If it is not specified, then the default user of ==`postgres`== will be used.

Be aware that if this parameter is specified, PostgreSQL will still show `The files belonging to this database system will be owned by user "postgres"` during initialization. This refers to the Linux system user (from `/etc/passwd` in the image) that the `postgres` daemon runs as, and as such is unrelated to the `POSTGRES_USER` option. See the section titled "Arbitrary `--user` Notes" for more details.

##### 3. `POSTGRES_DB`

This optional environment variable can be used to define a different name for the default database that is created when the image is first started. If it is not specified, then the value of `POSTGRES_USER` will be used.

### Docker Ports

`-p <host_port>:<docker_port>`

As a docker has **his own port structure inside**, we should to define which port would be used inside
Host port => our port to use

*Hint: As our project has no more docker containers now, and we will not try to use several ports now, just define a default ports to PostgreSQL, inside and outside:*
*5432.*


