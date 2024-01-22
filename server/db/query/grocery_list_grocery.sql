-- name: GetGroceryListGroceries :many
SELECT
  grocery_list_grocery.*,
  grocery_list.name AS grocery_list_name,
  grocery.name,
  grocery.category
FROM
  grocery_list_grocery
  LEFT JOIN grocery ON grocery_list_grocery.grocery = grocery.id
  LEFT JOIN grocery_list ON grocery_list_grocery.grocery_list = grocery_list.id
WHERE
  grocery_list_grocery.active = TRUE
  AND grocery_list = $1
ORDER BY
  grocery_list_grocery.created DESC;

-- name: CreateGroceryListGrocery :one
INSERT INTO grocery_list_grocery(grocery_list, grocery, quantity, price)
  VALUES ($1, $2, $3, $4)
RETURNING
  *;

-- name: UpdateGroceryListGrocery :one
UPDATE
  grocery_list_grocery
SET
  quantity = $2,
  price = $3
WHERE
  grocery = $1
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

