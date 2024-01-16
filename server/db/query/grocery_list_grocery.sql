-- name: GetGroceryListGroceries :many
SELECT
  *
FROM
  grocery_list_grocery
  LEFT JOIN grocery ON grocery_list_grocery.grocery = grocery.id
WHERE
  grocery_list = $1;

-- name: CreateGroceryListGrocery :one
INSERT INTO grocery_list_grocery(grocery_list, grocery, quantity, price)
  VALUES ($1, $2, $3, $4)
RETURNING
  *;

-- name: UpdateGroceryListGrocery :one
UPDATE
  grocery_list_grocery
SET
  grocery_list = $2,
  quantity = $3,
  price = $4
WHERE
  id = $1
RETURNING
  *;

-- name: DeleteGroceryListGrocery :one
UPDATE
  grocery_list_grocery
SET
  active = NOT active
WHERE
  id = $1
RETURNING
  *;

