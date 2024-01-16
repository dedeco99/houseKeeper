-- name: GetGroceries :many
SELECT
  *
FROM
  grocery
WHERE
  active = TRUE
ORDER BY
  name DESC
LIMIT $1 OFFSET $2;

-- name: CreateGrocery :one
INSERT INTO grocery(name, category, default_quantity, default_price)
  VALUES ($1, $2, $3, $4)
RETURNING
  *;

-- name: UpdateGrocery :one
UPDATE
  grocery
SET
  name = $2,
  category = $3,
  default_quantity = $4,
  default_price = $5
WHERE
  id = $1
RETURNING
  *;

-- name: DeleteGrocery :one
UPDATE
  grocery
SET
  active = NOT active
WHERE
  id = $1
RETURNING
  *;

