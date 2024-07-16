

Before starting download a special lib, to work with it:

```bash
$ go get github.com/lib/pq
```

```go
package sqlc  
  
import (  
    "context"  
    "github.com/jackc/pgx/v5"    "log"    "os"    "testing")  
  
const (  
    dbDriver = "postgres"  
    dbSource = "postgresql://root:qwerty123@localhost:5432/simple_bank?sslmode=disable"  
)  
  
var testQueries *Queries  
  
func TestMain(m *testing.M) {  
    ctx := context.Background()  
  
    pool, err := pgx.Connect(ctx, dbSource)  
    if err != nil {  
       log.Fatalf("Unable to connect to database: %v\n", err)  
    }  
  
    defer func(pool *pgx.Conn, ctx context.Context) {  
       err := pool.Close(ctx)  
       if err != nil {  
          log.Fatalf("Unable to close database connection: %v\n", err)  
       }  
    }(pool, ctx)  
  
    testQueries = New(pool)  
  
    os.Exit(m.Run())  
}
```

Example of code to start a test db connections


### To test a data, just use a ready lib: [testify](https://github.com/stretchr/testify):

```bash
$ go get github.com/stretchr/testify
```

### Example of using testify:

```go
func TestCreateAccount(t *testing.T) {  
    arg := CreateAccountParams{  
       Owner:    "owner",  
       Balance:  100,  
       Currency: "USD",  
    }  
  
    account, err := testQueries.CreateAccount(context.Background(), arg)  
  
    require.NoError(t, err)  
    require.NotEmpty(t, account)  
  
    require.Equal(t, arg.Owner, account.Owner)  
    require.Equal(t, arg.Balance, account.Balance)  
    require.Equal(t, arg.Currency, account.Currency)  
  
    require.NotZero(t, account.ID)  
    require.NotZero(t, account.CreatedAt)  
}
```

