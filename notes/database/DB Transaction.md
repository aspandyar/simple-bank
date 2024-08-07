


![[Pasted image 20240717010637.png]]![[Pasted image 20240717010613.png]]![[Pasted image 20240717010700.png]]
![[Pasted image 20240717010715.png]]

### To learn more about [[Transaction Isolation Levels]]

![[Pasted image 20240717010745.png]]

## To block a any other transaction, when one is running, use a FOR UPDATE query in PostgreSQL, to know more, see [website](https://vladmihalcea.com/postgresql-for-no-key-update/)

the **FOR UPDATE** clause is used to take an exclusive lock on a table record that will prevent any concurrent transaction from executing an UPDATE or DELETE statement on the locked record until the locking transaction ends via a commit or a rollback.


```sql
-- name: GetAccountForUpdate :one  
SELECT * FROM accounts  
WHERE id = $1  
FOR UPDATE;
```



#### NOTE: blocking some type of TX would leads to [[Deadlock `FOR UPDATE`]], so see following page, how to avoid it!


```sql
-- name: AddAccountBalance :one  
UPDATE accounts  
SET balance = balance + sqlc.arg(amount)  
WHERE id = sqlc.arg(id)  
RETURNING *;
```

in sqlc, we can show what var should we have by `sqlc.arg(name)`


----



