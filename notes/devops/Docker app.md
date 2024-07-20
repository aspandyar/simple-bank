


### visit https://hub.docker website and find a golang image:

[link](https://hub.docker.com/_/golang)


To produce a short image product, make a **alpine image**

Select a needful image: **golang:1.21-alpine3.19**

```Dockerfile
FROM golang:1.21-alpine3.19  
WORKDIR /app  
COPY . .  
RUN go build -o main main.go  
  
EXPOSE 8080  
CMD [ "/app/main" ]
```


`COPY . .` => would copy anything from current folder, where we run docker build command (from root of our project). Second dot would copy anything inside a an **image working root: /app**
`EXPOSE` => container would be run in same port as app
`CMD` => default command to run 

### Build image:

```bash
$ docker build -t simple-bank:latest .
```


### Convert docker file into multistage

```Dockerfile
# Build stage  
FROM golang:1.21-alpine3.19 AS builder  
WORKDIR /app  
COPY . .  
RUN go build -o main main.go  
  
# Run stage  
FROM alpine:3.19  
WORKDIR /app  
COPY --from=builder /app/main .  
COPY app.env .
  
EXPOSE 8080  
CMD [ "/app/main" ]
```

And run again same build command.

Here output:

```bash
REPOSITORY    TAG       IMAGE ID       CREATED              SIZE
simple-bank   latest    8b73ff9d9bd1   About a minute ago   21.3MB
```

-----------------

### Start container:

```bash
$ docker run --name simple-bank -p 8080:8080 -e GIN_MODE=release simple-bank:latest 
```

Here we also make a gin env mode release form debug

BUT our two containers: postgres and app, are not connected

### Using docker network to connect two containers


To check on what ports they run:

```bash
docker container inspect [docker_container]
```

Here output:

Postgres:

```JSON
     "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "02:42:ac:11:00:02",
                    "NetworkID": "b6b64f6fcb0c9273e21de14c89a40e0329adb1a4eef4f6927ec4b29ea4838322",
                    "EndpointID": "e71bc16e93678e36a9b7bad0d43d05bb172f275da4d8e65abb5a060d52f9a82f",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DriverOpts": null,
                    "DNSNames": null
                }
            }

```

App:
```JSON
 "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "b0dcfe2ad677a1da50281e00c33960e3ee2aad405015f8db00f667809e243a27",
            "SandboxKey": "/run/user/1000/docker/netns/b0dcfe2ad677",
            "Ports": {
                "8080/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "8080"
                    },
                    {
                        "HostIp": "::",
                        "HostPort": "8080"
                    }
                ]
            },
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "357a3a1dbc7570fdf809a39b60b4b9b3146b65e7173c137a702ca4ad316ca93b",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.3",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:03",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "02:42:ac:11:00:03",
                    "NetworkID": "b6b64f6fcb0c9273e21de14c89a40e0329adb1a4eef4f6927ec4b29ea4838322",
                    "EndpointID": "357a3a1dbc7570fdf809a39b60b4b9b3146b65e7173c137a702ca4ad316ca93b",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DriverOpts": null,
                    "DNSNames": null
                }
            }
        }
```


`See to "IPAddress"`

#### To connect one container to another using *bad way*:

Replace a docker postgres localhost port to real port: 172.17.0.2 in our example

here how: 
`docker run ... -e DB_SOURCE=postgresql://root:qwerty123@localhost:5432/simple_bank?sslmode=disable ...`

To:
`docker run ... -e DB_SOURCE=postgresql://root:qwerty123@172.17.0.2:5432/simple_bank?sslmode=disable ...`



### Using docker network

```bash
[aspandyar@fedora ~]$ docker network ls
NETWORK ID     NAME                  DRIVER    SCOPE
b6b64f6fcb0c   bridge                bridge    local
6b85dfc474e7   forum-js_default      bridge    local
70690011851c   host                  host      local
eb69e165c59e   kariercraft_default   bridge    local
99d384d83bc7   none                  null      local
[aspandyar@fedora ~]$ 
```

see what network are used

```bash
[aspandyar@fedora ~]$ docker network inspect bridge 
```

to see more deep what is used

##### By default a `bridge` docker network is used to all containers

```JSON
  "Containers": {
            "8832fd7f889c697a5e4dd2a2adb7f1052adfa65ef172687bf9f715e81733f3e9": {
                "Name": "simple-bank-postgres",
                "EndpointID": "e71bc16e93678e36a9b7bad0d43d05bb172f275da4d8e65abb5a060d52f9a82f",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.17.0.2/16",
                "IPv6Address": ""
            },
            "c389a711c070bf245c2520f75177cbdfb4e2896d0cd0a42c931c4762952933af": {
                "Name": "simple-bank-app",
                "EndpointID": "357a3a1dbc7570fdf809a39b60b4b9b3146b65e7173c137a702ca4ad316ca93b",
                "MacAddress": "02:42:ac:11:00:03",
                "IPv4Address": "172.17.0.3/16",
                "IPv6Address": ""
            }
        },
```

#### Create a network:

```bash
[aspandyar@fedora ~]$ docker network create simple-bank-network
00b7c4963711b147e1168989067ef4f3d31a59c990266ca41374dc4ff0487aa0
[aspandyar@fedora ~]$ docker network ls
NETWORK ID     NAME                  DRIVER    SCOPE
b6b64f6fcb0c   bridge                bridge    local
70690011851c   host                  host      local
99d384d83bc7   none                  null      local
00b7c4963711   simple-bank-network   bridge    local
[aspandyar@fedora ~]$ 
```

### Then connect to that network:

```bash
[aspandyar@fedora ~]$ docker network connect simple-bank-network simple-bank-postgres 
[aspandyar@fedora ~]$ docker container inspect simple-bank-postgres 
```

```JSON
"Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "02:42:ac:11:00:02",
                    "NetworkID": "b6b64f6fcb0c9273e21de14c89a40e0329adb1a4eef4f6927ec4b29ea4838322",
                    "EndpointID": "e71bc16e93678e36a9b7bad0d43d05bb172f275da4d8e65abb5a060d52f9a82f",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DriverOpts": null,
                    "DNSNames": null
                },
                "simple-bank-network": {
                    "IPAMConfig": {},
                    "Links": null,
                    "Aliases": [],
                    "MacAddress": "02:42:ac:12:00:02",
                    "NetworkID": "00b7c4963711b147e1168989067ef4f3d31a59c990266ca41374dc4ff0487aa0",
                    "EndpointID": "d80069342ef6c22563634337464dc56ffbe5519ce76b601cdd40ebf7fc992c9a",
                    "Gateway": "172.18.0.1",
                    "IPAddress": "172.18.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DriverOpts": {},
                    "DNSNames": [
                        "simple-bank-postgres",
                        "8832fd7f889c"
                    ]
                }
            }
```

It is now connect to **two** networks

To connect a docker, which would created:

```bash
$ docker run ... --network simple-bank-network ...
```

```bash
[aspandyar@fedora ~]$ docker run -d --name simple-bank-app --network simple-bank-network -p 8080:8080 -e GIN_MODE=release simple-bank:latest
ca88624b648a7906ae2504be5c320b50a5db0397165c52865dc83638bf8acd1a
```

AND change localhost of DB to container name:

```.env
DB_SOURCE=postgresql://root:qwerty123@simple-bank-postgres:5432/simple_bank?sslmode=disable
```

