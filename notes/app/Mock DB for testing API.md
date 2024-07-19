
![[Pasted image 20240717224339.png]]

### Overall we make a additional DB for testing purpose

#### To download it visit website on [github](https://github.com/uber-go/mock)

```bash
$ go install go.uber.org/mock/mockgen@latest
```


use `mockgen` to generate mock files in directory

```bash
$ mockgen -destination db/mock/store.go github.com/aspandyar/simple-bank/db/sqlc Store 
```

here how db should be set up:

```
type Store interface {  
    Querier  
    TransferTx(ctx context.Context, arg TransferTxParams) (TransferTxResult, error)  
}
```
 


### To fully understand how to make that tests, withing github:

- https://github.com/aspandyar/simple-bank
They are all applied in /api/*_test.go files



### There are can be a problem, which would require a custom gomock.Eq function, here how to do it:


```go
type eqCreateUserMatcher struct {  
    arg      db.CreateUserParams  
    password string  
}  
  
func (e eqCreateUserMatcher) Matches(x any) bool {  
    arg, ok := x.(db.CreateUserParams)  
  
    if !ok {  
       return false  
    }  
  
    err := util.CheckPassword(e.password, arg.HashedPassword)  
    if err != nil {  
       return false  
    }  
  
    e.arg.HashedPassword = arg.HashedPassword  
    return reflect.DeepEqual(e.arg, arg)  
}  
  
func (e eqCreateUserMatcher) String() string {  
    return fmt.Sprintf("matches arg: %v and password %v", e.arg, e.password)  
}  
  
func eqCreateUserParams(arg db.CreateUserParams, password string) gomock.Matcher {  
    return eqCreateUserMatcher{arg: arg, password: password}  
}
```

They are done just by in code function of gomock.Eq()