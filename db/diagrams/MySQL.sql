CREATE TABLE `users` (
  `username` varchar(255) PRIMARY KEY,
  `hashed_password` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) UNIQUE NOT NULL,
  `password_changed_at` timestamptz NOT NULL DEFAULT '0001-01-01 00:00:00Z',
  `created_at` timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE `accounts` (
  `id` bigserial PRIMARY KEY,
  `owner` varchar(255) NOT NULL COMMENT 'one to many, because user can have several currency',
  `balance` bigint NOT NULL,
  `currency` varchar(255) NOT NULL,
  `created_at` timestamptz NOT NULL DEFAULT 'now()'
);

CREATE TABLE `entries` (
  `id` bigserial PRIMARY KEY,
  `account_id` bigint NOT NULL,
  `amount` bigint NOT NULL COMMENT 'can be negative and positive',
  `created_at` timestamptz NOT NULL DEFAULT 'now()'
);

CREATE TABLE `transfers` (
  `id` bigserial PRIMARY KEY,
  `from_account_id` bigint NOT NULL,
  `to_account_id` bigint NOT NULL,
  `amount` bigint NOT NULL COMMENT 'can be only positive',
  `created_at` timestamptz NOT NULL DEFAULT 'now()'
);

CREATE INDEX `accounts_index_0` ON `accounts` (`owner`);

CREATE UNIQUE INDEX `accounts_index_1` ON `accounts` (`owner`, `currency`);

CREATE INDEX `entries_index_2` ON `entries` (`account_id`);

CREATE INDEX `transfers_index_3` ON `transfers` (`from_account_id`);

CREATE INDEX `transfers_index_4` ON `transfers` (`to_account_id`);

CREATE INDEX `transfers_index_5` ON `transfers` (`from_account_id`, `to_account_id`);

ALTER TABLE `accounts` ADD FOREIGN KEY (`owner`) REFERENCES `users` (`username`);

ALTER TABLE `entries` ADD FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`);

ALTER TABLE `transfers` ADD FOREIGN KEY (`from_account_id`) REFERENCES `accounts` (`id`);

ALTER TABLE `transfers` ADD FOREIGN KEY (`to_account_id`) REFERENCES `accounts` (`id`);
