
```bash
Error Trace:    /home/aspandyar/Projects/simple-bank/db/sqlc/store_test.go:39
                Error:          Received unexpected error:
                                pq: deadlock detected
                Test:           TestTransferTx

```

### Why it happened?

```sql
BEGIN;  
  
INSERT INTO transfers (from_account_id, to_account_id, amount)  
VALUES (1, 2, 10)  
RETURNING *;  
  
INSERT INTO entries (account_id, amount)  
VALUES (1, -10)  
RETURNING *;  
  
INSERT INTO entries (account_id, amount)  
VALUES (2, 10)  
RETURNING *;  
  
SELECT * FROM accounts WHERE id = 1 FOR UPDATE;  
UPDATE accounts SET balance = balance - 10 WHERE id = 1 RETURNING *;  
  
SELECT * FROM accounts WHERE id = 2 FOR UPDATE;  
UPDATE accounts SET balance = balance + 10 WHERE id = 2 RETURNING *;  
  
ROLLBACK;
```

Let's go into our PostgreSQL in docker, to create a two real time sessions:

```bash
[aspandyar@fedora ~]$ docker exec -it simple-bank-postgres psql -U root -d simple_bank
psql (16.3 (Debian 16.3-1.pgdg120+1))
Type "help" for help.

simple_bank=# \d
               List of relations
 Schema |       Name        |   Type   | Owner 
--------+-------------------+----------+-------
 public | accounts          | table    | root
 public | accounts_id_seq   | sequence | root
 public | entries           | table    | root
 public | entries_id_seq    | sequence | root
 public | schema_migrations | table    | root
 public | transfers         | table    | root
 public | transfers_id_seq  | sequence | root
(7 rows)

simple_bank=# 
```

### NOW we should some steps in specific order, because all operations would be happen in one time:

![[Pasted image 20240717134427.png]]

#### TX 2: 
create transfer, create entry 1
```SQL
simple_bank=# BEGIN;
BEGIN
simple_bank=*# INSERT INTO transfers (from_account_id, to_account_id, amount)
VALUES (1, 2, 10)
RETURNING *;
 id  | from_account_id | to_account_id | amount |          created_at           
-----+-----------------+---------------+--------+-------------------------------
 119 |               1 |             2 |     10 | 2024-07-16 16:50:23.224489+00
(1 row)

INSERT 0 1
simple_bank=*# INSERT INTO entries (account_id, amount)
VALUES (1, -10)
RETURNING *;
 id  | account_id | amount |          created_at           
-----+------------+--------+-------------------------------
 161 |          1 |    -10 | 2024-07-16 16:50:23.224489+00
(1 row)

INSERT 0 1
simple_bank=*# 
```

#### TX 1:
create transfer
```sql
simple_bank=# BEGIN;
BEGIN
simple_bank=*# INSERT INTO transfers (from_account_id, to_account_id, amount)
VALUES (1, 2, 10)
RETURNING *;
 id  | from_account_id | to_account_id | amount |          created_at           
-----+-----------------+---------------+--------+-------------------------------
 120 |               1 |             2 |     10 | 2024-07-16 16:50:23.224489+00
(1 row)

INSERT 0 1
simple_bank=*# 

```

#### TX 2:
create entry 2, get account 1
```sql
simple_bank=*# INSERT INTO entries (account_id, amount)
VALUES (2, 10)
RETURNING *;
 id  | account_id | amount |          created_at           
-----+------------+--------+-------------------------------
 162 |          2 |     10 | 2024-07-16 16:50:23.224489+00
(1 row)

INSERT 0 1
simple_bank=*# SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
[]
```
HERE TX 2 was blocked!!!

#### TX 1:
create entry 1, create entry 2, get account 1, update account 1
```sql
imple_bank=*# INSERT INTO entries (account_id, amount)
VALUES (1, -10)
RETURNING *;
 id  | account_id | amount |          created_at           
-----+------------+--------+-------------------------------
 163 |          1 |    -10 | 2024-07-16 16:50:23.224489+00
(1 row)

INSERT 0 1
simple_bank=*# INSERT INTO entries (account_id, amount)
VALUES (2, 10)
RETURNING *;
 id  | account_id | amount |          created_at           
-----+------------+--------+-------------------------------
 164 |          2 |     10 | 2024-07-16 16:50:23.224489+00
(1 row)

INSERT 0 1
simple_bank=*# SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
ERROR:  deadlock detected
DETAIL:  Process 186 waits for ShareLock on transaction 1266; blocked by process 174.
Process 174 waits for ShareLock on transaction 1267; blocked by process 186.
HINT:  See server log for query details.
CONTEXT:  while locking tuple (0,1) in relation "accounts"
simple_bank=!# 

```

### If you run it on more old PostgreSQL versions, deadlock can not be detected, so to check it, run following query:

```sql
simple_bank=# SELECT a.application_name, l.relation::regclass, l.transactionid, l.mode, l.locktype, l.GRANTED, a.usename, a.query, a.pid
FROM pg_stat_activity a
JOIN pg_locks l ON l.pid = a.pid
WHERE a.application_name = 'psql'
ORDER BY a.pid;
```

![[Pasted image 20240717135538.png]]

### FOR NO KEY UPDATE

Because we call a FOR UPDATE, it would block any quires, which are seems to be used, even a Foreign Key in our example: 

If we would to search a what was leads to our error, we go a following line:

```sql
ALTER TABLE "entries" ADD FOREIGN KEY ("account_id") REFERENCES "accounts" ("id");  
  
ALTER TABLE "transfers" ADD FOREIGN KEY ("from_account_id") REFERENCES "accounts" ("id");  
  
ALTER TABLE "transfers" ADD FOREIGN KEY ("to_account_id") REFERENCES "accounts" ("id");
```

So, while a SELECT is called, it would block a relations, with FK there.

To prevent it, just change a FOR UPDATE to **`FOR NO KEY UPDATE`**

