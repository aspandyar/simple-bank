

Before starting download a special lib, to work with it:

```bash
$ go get github.com/lib/pq
```

it should be import to `main_test.go` file to define a postgres Driver here.


```go
package db  
  
import (  
    "database/sql"  
    "log"    "os"    "testing"  
    _ "github.com/lib/pq"  // following import not used, but it should be here!!!
)  
  
const (  
    dbDriver = "postgres"  
    dbSource = "postgresql://root:qwerty123@localhost:5432/simple_bank?sslmode=disable"  
)  
  
var testQueries *Queries  
  
func TestMain(m *testing.M) {  
    conn, err := sql.Open(dbDriver, dbSource)  
    if err != nil {  
       log.Fatal("cannot connect to db:", err)  
    }  
  
    testQueries = New(conn)  
  
    os.Exit(m.Run())  
}
```


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



#### To handle DB Error:

`you can use following code to handle db error:`

```go
if err != nil {
	if pqErr, ok := err.(*pq.Error); ok {
		log.Println(pqErr.Code.Name())
	}
}
```

OR

```go
var pqErr *pq.Error  
if errors.As(err, &pqErr) {  
    log.Println(pqErr.Code.Name())  
}
```

