

## Golang basic libs:
![[Pasted image 20240717203813.png]]

### Download [gin](https://github.com/gin-gonic/gin):

```bash
$ go get -u github.com/gin-gonic/gin
```

### Golang struct:

```go
type createAccountRequest struct {  
    Owner    string `json:"owner" binding:"required"`  
    Currency string `json:"currency" biding:"required,oneof=USD EUR CAD"`  
}
```

