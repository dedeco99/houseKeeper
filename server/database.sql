CREATE DATABASE housekeeper;

-- Groceries
CREATE TABLE grocery(
  id uuid PRIMARY KEY NOT NULL,
  active boolean NOT NULL DEFAULT TRUE,
  name text NOT NULL,
  category uuid REFERENCES category(id),
  default_quantity smallint NOT NULL DEFAULT 1,
  default_price money NOT NULL DEFAULT 0,
  created timestamp
);

CREATE TABLE category(
  id uuid PRIMARY KEY NOT NULL,
  active boolean NOT NULL DEFAULT TRUE,
  name text NOT NULL,
  created timestamp
);

CREATE TABLE grocery_list(
  id uuid PRIMARY KEY NOT NULL,
  active boolean NOT NULL DEFAULT TRUE,
  name text NOT NULL,
  created timestamp
);

CREATE TABLE grocery_list_grocery(
  id uuid PRIMARY KEY NOT NULL,
  grocery_list uuid REFERENCES grocery_list(id) NOT NULL,
  grocery uuid REFERENCES grocery(id) NOT NULL,
  quantity smallint NOT NULL DEFAULT 1,
  price money NOT NULL DEFAULT 0,
  created timestamp
);

-- Users
CREATE TABLE profile(
  id uuid PRIMARY KEY NOT NULL,
  active boolean NOT NULL DEFAULT TRUE,
  name text NOT NULL,
  email text NOT NULL,
  household uuid REFERENCES household(id),
  created timestamp,
  UNIQUE (email)
);

CREATE TABLE household(
  id uuid PRIMARY KEY NOT NULL,
  active boolean NOT NULL DEFAULT TRUE,
  name text NOT NULL,
  created timestamp
);
