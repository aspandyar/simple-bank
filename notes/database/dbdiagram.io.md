[website](https://dbdiagram.io)

Following code contains a ==dbdiagram.io== syntax, which can easily change format in any SQL syntax in their website.

```sql
Table accounts as A {
	id bigserial [pk]
	owner varchar [not null]
	balance bigint [not null]
	currency varchar [not null]
	created_at timestamptz [not null, default: 'now()']

	indexes {
		owner
	}
}
```

```sql
Table entries {
	id bigserial [pk]
	account_id bigint [ref: > A.id, not null]
	amount bigint [not null, note: 'can be negative and positive']
	created_at timestamptz [not null, default: 'now()']

	indexes {
		account_id
	}
}
```

 ```sql
Table transfers {
	id bigserial [pk]
	from_account_id bigint [ref: > A.id, not null]
	to_account_id bigint [ref: > A.id, not null]
	amount bigint [not null, note: 'can be only positive']
	created_at timestamptz [not null, default: 'now()']

	indexes {
		from_account_id
		to_account_id
		(from_account_id, to_account_id)
	}
}
```

## ERD

![[Simple Bank.png]]

