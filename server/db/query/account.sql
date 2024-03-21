-- name: GetAccounts :many
SELECT
  *
FROM
  account
ORDER BY
  id
LIMIT $1 OFFSET $2;

-- name: GetAccount :one
SELECT
  *
FROM
  account
WHERE
  id = $1
LIMIT 1;

-- name: CreateAccount :one
INSERT INTO account(name, email)
  VALUES ($1, $2)
RETURNING
  *;

-- name: UpdateAccount :one
UPDATE
  account
SET
  name = $2,
  email = $3
WHERE
  id = $1
RETURNING
  *;

-- name: DeleteAccount :one
UPDATE
  account
SET
  active = NOT active
WHERE
  id = $1
RETURNING
  *;

