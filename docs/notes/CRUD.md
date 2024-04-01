
### What is CRUD?

- Create
	- Insert new records to the database
- Read
	- Select or search for records in the database
- Update
	- Change some fields of the record in the database
- Delete
	- Remove records from the database

### Things to Consider (Golang)

- #### Database/[SQL](https://pkg.go.dev/database/sql)
	+ Very fast & straightforward
	+ Manual mapping SQL fields to variables
	+ Easy to make mistakes, not caught until runtime
+ #### [GORM](https://gorm.io/index.html)
	+ CRUD functions already implemented, very short production code
	+ Must learn to write queries using GORM's functions
	+ Run slowly on high load
+ #### [SQLX](https://github.com/jmoiron/sqlx)
	+ Quite fast & easy to use
	+ Fields mapping via query text & struct tags
	+ Failure won't occur until runtime
+ #### [SQLC](https://github.com/sqlc-dev/sqlc)
	+ Very fast & easy to use
	+ Automatic code generation
	+ Catch SQL query errors before generating code
