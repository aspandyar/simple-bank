
![[Potential Deadlock.png]]

### [[Potential Deadlock.canvas|Potential Deadlock]]


Following deadlock can leads to several problem, so to handle it make a ==correct queries order!==

Here how to call that deadlock:
![[Pasted image 20240717142449.png]]

It means that it can be happened due to a huge number of customers

### Here example of sql code, which would work without deadlock:

![[Pasted image 20240717142650.png]]

```go
if arg.FromAccountID < arg.ToAccountID {  
    result.FromAccount, err = queries.AddAccountBalance(ctx, AddAccountBalanceParams{  
       ID:     arg.FromAccountID,  
       Amount: -arg.Amount,  
    })  
    if err != nil {  
       return err  
    }  
  
    result.ToAccount, err = queries.AddAccountBalance(ctx, AddAccountBalanceParams{  
       ID:     arg.ToAccountID,  
       Amount: arg.Amount,  
    })  
    if err != nil {  
       return err  
    }  
} else {  
    result.ToAccount, err = queries.AddAccountBalance(ctx, AddAccountBalanceParams{  
       ID:     arg.ToAccountID,  
       Amount: arg.Amount,  
    })  
    if err != nil {  
       return err  
    }  
  
    result.FromAccount, err = queries.AddAccountBalance(ctx, AddAccountBalanceParams{  
       ID:     arg.FromAccountID,  
       Amount: -arg.Amount,  
    })  
    if err != nil {  
       return err  
    }  
}
```


Following order, would leads to our solution

### Simplified version to avoid repeating:

```go
func addMoney(  
    ctx context.Context,  
    queries *Queries,  
    accountID1 int64,  
    amount1 int64,  
    accountID2 int64,  
    amount2 int64,  
) (account1 Account, account2 Account, err error) {  
    account1, err = queries.AddAccountBalance(ctx, AddAccountBalanceParams{  
       ID:     accountID1,  
       Amount: amount1,  
    })  
    if err != nil {  
       return  
    }  
  
    account2, err = queries.AddAccountBalance(ctx, AddAccountBalanceParams{  
       ID:     accountID2,  
       Amount: amount2,  
    })  
    if err != nil {  
       return  
    }  
  
    return  
}



  
// get updated account balance  
{
	if arg.FromAccountID < arg.ToAccountID {  
	    result.FromAccount, result.ToAccount, err = addMoney(  
	       ctx, queries, arg.FromAccountID, -arg.Amount, arg.ToAccountID, arg.Amount)  
	} else {  
	    result.ToAccount, result.FromAccount, err = addMoney(  
	       ctx, queries, arg.ToAccountID, arg.Amount, arg.FromAccountID, -arg.Amount)  
	}
}
```