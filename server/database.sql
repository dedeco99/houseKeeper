CREATE DATABASE housekeeper;

-- Groceries
CREATE TABLE category(
  id uuid PRIMARY KEY NOT NULL DEFAULT public.uuid_generate_v4(),
  active boolean NOT NULL DEFAULT TRUE,
  name text NOT NULL,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE grocery(
  id uuid PRIMARY KEY NOT NULL DEFAULT public.uuid_generate_v4(),
  active boolean NOT NULL DEFAULT TRUE,
  name text NOT NULL,
  category uuid REFERENCES category(id),
  default_quantity smallint NOT NULL DEFAULT 1,
  default_price numeric NOT NULL DEFAULT 0,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE grocery_list(
  id uuid PRIMARY KEY NOT NULL DEFAULT public.uuid_generate_v4(),
  active boolean NOT NULL DEFAULT TRUE,
  name text NOT NULL,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE grocery_list_grocery(
  id uuid PRIMARY KEY NOT NULL DEFAULT public.uuid_generate_v4(),
  grocery_list uuid REFERENCES grocery_list(id) NOT NULL,
  grocery uuid REFERENCES grocery(id) NOT NULL,
  quantity smallint NOT NULL DEFAULT 1,
  price money NOT NULL DEFAULT 0,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Users
CREATE TABLE profile(
  id uuid PRIMARY KEY NOT NULL DEFAULT public.uuid_generate_v4(),
  active boolean NOT NULL DEFAULT TRUE,
  name text NOT NULL,
  email text NOT NULL,
  household uuid REFERENCES household(id),
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (email)
);

CREATE TABLE household(
  id uuid PRIMARY KEY NOT NULL DEFAULT public.uuid_generate_v4(),
  active boolean NOT NULL DEFAULT TRUE,
  name text NOT NULL,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

