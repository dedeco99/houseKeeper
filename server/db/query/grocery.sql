-- name: GetGroceries :many
SELECT
  grocery.*,
  grocery_category.name AS category_name
FROM
  grocery
  LEFT JOIN grocery_category ON grocery.category = grocery_category.id
WHERE
  grocery.active = TRUE
ORDER BY
  grocery.name DESC;

-- name: AddGrocery :one
INSERT INTO grocery(name, category, default_quantity, default_price)
  VALUES ($1, $2, $3, $4)
RETURNING
  *;

-- name: EditGrocery :one
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

