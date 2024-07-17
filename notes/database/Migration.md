
In following project, we would use a golang [migrate](https://github.com/golang-migrate/migrate) library

```bash
[aspandyar@fedora simple-bank]$ migrate --help
Usage: migrate OPTIONS COMMAND [arg...]
       migrate [ -version | -help ]

Options:
  -source          Location of the migrations (driver://url)
  -path            Shorthand for -source=file://path
  -database        Run migrations against this database (driver://url)
  -prefetch N      Number of migrations to load in advance before executing (default 10)
  -lock-timeout N  Allow N seconds to acquire database lock (default 15)
  -verbose         Print verbose logging
  -version         Print version
  -help            Print usage

Commands:
  create [-ext E] [-dir D] [-seq] [-digits N] [-format] [-tz] NAME
	   Create a set of timestamped up/down migrations titled NAME, in directory D with extension E.
	   Use -seq option to generate sequential up/down migrations with N digits.
	   Use -format option to specify a Go time format string. Note: migrations with the same time cause "duplicate migration version" error.
           Use -tz option to specify the timezone that will be used when generating non-sequential migrations (defaults: UTC).

  goto V       Migrate to version V
  up [N]       Apply all or N up migrations
  down [N] [-all]    Apply all or N down migrations
	Use -all to apply all down migrations
  drop [-f]    Drop everything inside database
	Use -f to bypass confirmation
  force V      Set version V but don't run migration (ignores dirty state)
  version      Print current migration version

Source drivers: go-bindata, github-ee, bitbucket, s3, gcs, file, github, gitlab, godoc-vfs
Database drivers: neo4j, mongodb+srv, sqlserver, stub, clickhouse, mysql, postgresql, cassandra, pgx5, crdb-postgres, spanner, ysql, firebirdsql, cockroach, postgres, yugabytedb, redshift, yugabyte, rqlite, mongodb, firebird, pgx, pgx4, cockroachdb
```

Example of init migration in any project:

```bash
$ migrate create -ext sql -dir db/migration -seq init_schema
```

`-ext` => file extension, in our example it would be sql
`-dir` => directory
`-seq` => in migration files would be used a sequential numbers instead of timestamps (for better performance)
`init_schema` => name of migrations

### Migrate UP

![[Pasted image 20240716202651.png]]

### Migrate DOWN

![[Pasted image 20240716202718.png]]

