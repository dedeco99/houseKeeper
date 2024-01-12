CREATE TABLE "category" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (public.uuid_generate_v4()),
  "active" boolean NOT NULL DEFAULT true,
  "name" text NOT NULL,
  "created" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "grocery" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (public.uuid_generate_v4()),
  "active" boolean NOT NULL DEFAULT true,
  "name" text NOT NULL,
  "category" uuid,
  "default_quantity" smallint NOT NULL DEFAULT 1,
  "default_price" numeric NOT NULL DEFAULT 0,
  "created" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "grocery_list" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (public.uuid_generate_v4()),
  "active" boolean NOT NULL DEFAULT true,
  "name" text NOT NULL,
  "created" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "grocery_list_grocery" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (public.uuid_generate_v4()),
  "active" boolean NOT NULL DEFAULT true,
  "grocery_list" uuid NOT NULL,
  "grocery" uuid NOT NULL,
  "quantity" smallint NOT NULL DEFAULT 1,
  "price" numeric NOT NULL DEFAULT 0,
  "created" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "household" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (public.uuid_generate_v4()),
  "active" boolean NOT NULL DEFAULT true,
  "name" text NOT NULL,
  "created" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "account" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (public.uuid_generate_v4()),
  "active" boolean NOT NULL DEFAULT true,
  "name" text NOT NULL,
  "email" text NOT NULL,
  "household" uuid,
  "created" timestamp NOT NULL DEFAULT (now())
);

CREATE INDEX ON "category" ("active");

CREATE INDEX ON "category" ("name");

CREATE INDEX ON "grocery" ("active");

CREATE INDEX ON "grocery" ("name");

CREATE INDEX ON "grocery" ("category");

CREATE INDEX ON "grocery_list" ("active");

CREATE INDEX ON "grocery_list" ("name");

CREATE INDEX ON "grocery_list_grocery" ("active");

CREATE INDEX ON "grocery_list_grocery" ("grocery_list");

CREATE INDEX ON "grocery_list_grocery" ("grocery");

CREATE INDEX ON "household" ("active");

CREATE INDEX ON "household" ("name");

CREATE INDEX ON "account" ("active");

CREATE INDEX ON "account" ("name");

CREATE UNIQUE INDEX ON "account" ("email");

CREATE INDEX ON "account" ("household");

ALTER TABLE "grocery" ADD FOREIGN KEY ("category") REFERENCES "category" ("id");

ALTER TABLE "grocery_list_grocery" ADD FOREIGN KEY ("grocery_list") REFERENCES "grocery_list" ("id");

ALTER TABLE "grocery_list_grocery" ADD FOREIGN KEY ("grocery") REFERENCES "grocery" ("id");

ALTER TABLE "account" ADD FOREIGN KEY ("household") REFERENCES "household" ("id");
