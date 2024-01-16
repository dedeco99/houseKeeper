-- name: GetGroceryLists :many
SELECT
  *
FROM
  grocery_list
WHERE
  active = TRUE
ORDER BY
  created DESC
LIMIT $1 OFFSET $2;

-- name: GetGroceryList :one
SELECT
  *
FROM
  grocery_list_grocery
  LEFT JOIN grocery ON grocery_list_grocery.grocery = grocery.id
WHERE
  grocery_list = $1;

-- name: CreateGroceryList :one
INSERT INTO grocery_list(name)
  VALUES ($1)
RETURNING
  *;

-- name: UpdateGroceryList :one
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

