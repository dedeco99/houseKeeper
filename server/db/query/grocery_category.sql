-- name: GetGroceryCategories :many
SELECT
  *
FROM
  grocery_category
WHERE
  active = TRUE
ORDER BY
  name DESC;

-- name: AddGroceryCategory :one
INSERT INTO grocery_category(name)
  VALUES ($1)
RETURNING
  *;

-- name: EditGroceryCategory :one
UPDATE
  grocery_category
SET
  name = $2
WHERE
  id = $1
RETURNING
  *;

-- name: DeleteGroceryCategory :one
UPDATE
  grocery_category
SET
  active = NOT active
WHERE
  id = $1
RETURNING
  *;

