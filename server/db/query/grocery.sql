-- name: GetGroceries :many
SELECT
  *
FROM
  grocery
WHERE
  active = TRUE
ORDER BY
  name DESC;

-- name: AddGrocery :one
INSERT INTO grocery(name, default_quantity, default_price)
  VALUES ($1, $2, $3)
RETURNING
  *;

-- name: EditGrocery :one
UPDATE
  grocery
SET
  name = $2,
  default_quantity = $3,
  default_price = $4
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

