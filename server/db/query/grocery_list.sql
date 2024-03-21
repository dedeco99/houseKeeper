-- name: GetGroceryLists :many
SELECT
  *
FROM
  grocery_list
WHERE
  active = TRUE
ORDER BY
  created DESC;

-- name: AddGroceryList :one
INSERT INTO grocery_list(name)
  VALUES ($1)
RETURNING
  *;

-- name: EditGroceryList :one
UPDATE
  grocery_list
SET
  name = $2
WHERE
  id = $1
RETURNING
  *;

-- name: DeleteGroceryList :one
UPDATE
  grocery_list
SET
  active = NOT active
WHERE
  id = $1
RETURNING
  *;

