
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
 


