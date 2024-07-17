


# Viper
![[Pasted image 20240717222832.png]]

[download viper](https://github.com/spf13/viper)

```bash
$ go get github.com/spf13/viper
```

## Create a .env file: 

`app.env:`

```bash
DB_DRIVER=postgres  
DB_SOURCE=postgresql://root:qwerty123@localhost:5432/simple_bank?sslmode=disable 
SERVER_ADDRESS=0.0.0.0:8080
```

`main.go`

```go
package main  
  
import (  
    "database/sql"  
    "github.com/aspandyar/simple-bank/api"    db "github.com/aspandyar/simple-bank/db/sqlc"  
    "github.com/aspandyar/simple-bank/util"    "log"  
    _ "github.com/lib/pq"  
)  
  
func main() {  
    config, err := util.LoadConfig(".")  
    if err != nil {  
       log.Fatal("cannot load config:", err)  
    }  
  
    conn, err := sql.Open(config.DBDriver, config.DBSource)  
    if err != nil {  
       log.Fatal("cannot connect to db:", err)  
    }  
  
    store := db.NewStore(conn)  
    server := api.NewServer(store)  
  
    err = server.Start(config.ServerAddress)  
    if err != nil {  
       log.Fatal("cannot start server:", err)  
    }  
}
```

`config.go` 

```go
package util  
  
import "github.com/spf13/viper"  
  
// Config is the configuration for the application// It is used to configure the application  
type Config struct {  
    DBDriver      string `mapstructure:"DB_DRIVER"`  
    DBSource      string `mapstructure:"DB_SOURCE"`  
    ServerAddress string `mapstructure:"SERVER_ADDRESS"`  
}  
  
func LoadConfig(path string) (config Config, err error) {  
    viper.AddConfigPath(path)  
    viper.SetConfigName("app")  
    viper.SetConfigType("env")  
  
    viper.AutomaticEnv()  
  
    err = viper.ReadInConfig()  
    if err != nil {  
       return  
    }  
  
    err = viper.Unmarshal(&config)  
    return  
}
```

 