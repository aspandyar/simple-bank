## Navigation:

1. [Using Docker Hub to Download Container Images](#using-docker-hub-to-download-container-images)
2. [Starting a Container](#starting-a-container)
   - [Docker Environment Variables](#docker-environment-variables)
   - [Ports](#ports)
3. [Executing Commands in a Docker Container](#executing-commands-in-a-docker-container)
4. [Viewing Logs](#viewing-logs)
5. [Stopping a Docker Container](#stopping-a-docker-container)
6. [View containers and images](#view-containers-and-images)
7. [Starting containers](#starting-containers)

---

## Using Docker Hub to Download Container Images

You can use Docker Hub to download images of containers, such as PostgreSQL.

To download the PostgreSQL image, use the following command:

```bash
docker pull postgres
```

## Starting a Container

To start a container, you can use the following template:

```bash
docker run --name <container_name> -e <env_variable> -p <host_ports:container_ports> -d <image>:<tag>
```

### Docker Environment Variables

- `POSTGRES_PASSWORD`: Sets up the password for PostgreSQL.
- `POSTGRES_USER`: Sets up the user. The default user is `postgres`.
- `POSTGRES_DB`: Sets a default database, created when the image is first started. If not provided, `POSTGRES_USER` variable will be used.

### Ports

The `-p` flag specifies the mapping of host ports to container ports.

**Example**: `-p 5432:5432`

- **Host Port**: The port on which the container will run on the host system.
- **Container Port**: The port to which data will be sent from the host port inside the Docker container.

## Executing Commands in a Docker Container

You can execute commands within a Docker container using the following syntax:

```bash
docker exec -it <container_name_or_id> <command> [args]
```

Options:

- `-i`, `--interactive`: Keeps STDIN open even if not attached.
- `-t`, `--tty`: Allocates a pseudo-TTY.

To exit the execution of a container, type `\q`.

## Viewing Logs

To view the logs of a Docker container, use the following command:

```bash
docker logs <container_name_or_id>
```

## Stopping a Docker Container

To stop a Docker container, use the following command:

```bash
docker stop <container_name_or_id>
```

## View containers and images

To see **all images**, use the command:

```bash
docker image ls
```

To see **active** containers:

```bash
docker ps
```

To see **all** containers:

```bash
docker ps -a
```

## Starting containers

You can start a Docker container using the following syntax:

```bash
docker start <container_name_or_id>
```

