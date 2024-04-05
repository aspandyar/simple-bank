##### What is db transaction?
- A single unit of work
- Often made up of multiple db operations

##### Example:
	transfer 10 USD from bank account 1 to bank account 2


1. Create a transfer record with amount = 10
2. Create an account entry for account 1 with amount = -10
3. Create an account entry for account 1 with amount = +10
4. Subtract 10 from the balance of account 1
5. Add 10 to the balance of account 2

### Why do we need db transaction?

1. To provide a reliable and consistent unit of work, even in case of **system failure**
2. To provide isolation between programs that access the database **concurrently**

	To achieve that goals, our DB TX should satisfied to [[ACID]] property

