ALTER TABLE "accounts" DROP CONSTRAINT IF EXISTS "owner_currency_key";

COMMENT ON COLUMN "accounts"."owner" IS NULL;

ALTER TABLE "accounts" DROP CONSTRAINT IF EXISTS "accounts_owner_fkey";

DROP TABLE IF EXISTS "users";
