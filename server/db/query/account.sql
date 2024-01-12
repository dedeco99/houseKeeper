-- name: CreateAccount :one
INSERT INTO account(name, email)
  VALUES ($1, $2)
RETURNING
  *;

