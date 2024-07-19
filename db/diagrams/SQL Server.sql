CREATE TABLE [users] (
  [username] nvarchar(255) PRIMARY KEY,
  [hashed_password] nvarchar(255) NOT NULL,
  [full_name] nvarchar(255) NOT NULL,
  [email] nvarchar(255) UNIQUE NOT NULL,
  [password_changed_at] timestamptz NOT NULL DEFAULT '0001-01-01 00:00:00Z',
  [created_at] timestamptz NOT NULL DEFAULT (now())
)
GO

CREATE TABLE [accounts] (
  [id] bigserial PRIMARY KEY,
  [owner] nvarchar(255) NOT NULL,
  [balance] bigint NOT NULL,
  [currency] nvarchar(255) NOT NULL,
  [created_at] timestamptz NOT NULL DEFAULT 'now()'
)
GO

CREATE TABLE [entries] (
  [id] bigserial PRIMARY KEY,
  [account_id] bigint NOT NULL,
  [amount] bigint NOT NULL,
  [created_at] timestamptz NOT NULL DEFAULT 'now()'
)
GO

CREATE TABLE [transfers] (
  [id] bigserial PRIMARY KEY,
  [from_account_id] bigint NOT NULL,
  [to_account_id] bigint NOT NULL,
  [amount] bigint NOT NULL,
  [created_at] timestamptz NOT NULL DEFAULT 'now()'
)
GO

CREATE INDEX [accounts_index_0] ON [accounts] ("owner")
GO

CREATE UNIQUE INDEX [accounts_index_1] ON [accounts] ("owner", "currency")
GO

CREATE INDEX [entries_index_2] ON [entries] ("account_id")
GO

CREATE INDEX [transfers_index_3] ON [transfers] ("from_account_id")
GO

CREATE INDEX [transfers_index_4] ON [transfers] ("to_account_id")
GO

CREATE INDEX [transfers_index_5] ON [transfers] ("from_account_id", "to_account_id")
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'one to many, because user can have several currency',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'accounts',
@level2type = N'Column', @level2name = 'owner';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'can be negative and positive',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'entries',
@level2type = N'Column', @level2name = 'amount';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'can be only positive',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'transfers',
@level2type = N'Column', @level2name = 'amount';
GO

ALTER TABLE [accounts] ADD FOREIGN KEY ([owner]) REFERENCES [users] ([username])
GO

ALTER TABLE [entries] ADD FOREIGN KEY ([account_id]) REFERENCES [accounts] ([id])
GO

ALTER TABLE [transfers] ADD FOREIGN KEY ([from_account_id]) REFERENCES [accounts] ([id])
GO

ALTER TABLE [transfers] ADD FOREIGN KEY ([to_account_id]) REFERENCES [accounts] ([id])
GO
