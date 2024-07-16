
![[Pasted image 20240716205242.png]]

Way to apply CRUD in golang:

![[Pasted image 20240716205515.png]]

To download a sqlc, use following link:

	https://docs.sqlc.dev/en/latest/tutorials/getting-started-postgresql.html

Example of slqc.yml code:

```yml
version: "2"  
sql:  
  - engine: "postgresql"  
    queries: "./db/query"  
    schema: "./db/migration"  
    gen:  
      go:  
        package: "sqlc"  
        out: "./db/sqlc"  
        sql_package: "pgx/v5"
```

To generate a code by query:

```bash
$ sqcl generate
```

Following are example of query to generate code:

```sql
-- name: GetAccount :one  
SELECT * FROM accounts  
WHERE id = $1 LIMIT 1;  
  
-- name: ListAccount :many  
SELECT * FROM accounts  
ORDER BY id  
LIMIT $1  
OFFSET $2;  
  
-- name: CreateAccount :one  
INSERT INTO accounts (  
    owner,  
    balance,  
    currency  
) VALUES (  
    $1,  
    $2,  
    $3  
) RETURNING *;  
  
-- name: UpdateAccount :one  
UPDATE accounts  
    set balance = $2  
WHERE id = $1  
RETURNING *;  
  
  
-- name: DeleteAccount :exec  
DELETE FROM accounts  
WHERE id = $1;
```


### NOTE: If you would use a current version you should to make sure to download a special version of [golang lib](https://docs.sqlc.dev/en/latest/tutorials/getting-started-postgresql.html) for working with PostgreSQL:

```bash
$ go get github.com/jackc/pgx/v5
```

