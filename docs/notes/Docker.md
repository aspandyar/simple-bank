
### Using a [docker hub](https://hub.docker.com/) to download image of container to PostgresSQL or others.

```bash
docker pull postgres
```

### To start a container, here templates of code:

```bash
docker run --name <container_name> -e <env variable> -p <host_ports:container_ports> -d <image>:<tag>
```

#### Docker environment variables:

- `POSTGRES_PASSWORD` => set up **password** of PostgresSQL
- `POSTGRES_USER` => set up **user**, default user: ***postgres***
- `POSTGRES_DB` => set a default db, that created while *image first* started, default: `POSTGRES_USER` var will be used

#### Ports

`-p <host_ports:container_ports>`

Host Port: port on which container will be running in host system
Container Port: port to which data will be sending from host port (inside docker container system)

**Why?** After 2 hours of conversation with [tshipenchko](https://github.com/tshipenchko), we concluded that the provided link of ports is necessary because Docker needs to know which port data should be sent from and to which one. Overall, we believe that the ports of the second container may not be essential for execution, but they provide us with such functionality.

### To Exec docker container:

```bash
docker exec -it <container_name_or_id> <command> [args]
```

	-i, --interactive          Keep STDIN open even if not attached
	-t, --tty                  Allocate a pseudo-TTY

#### To out of execution container write: `\q`

### To view logs of docker container:

```bash
docker logs <container_name_or_id>
```

