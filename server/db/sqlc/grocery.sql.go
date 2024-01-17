// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.25.0
// source: grocery.sql

package db

import (
	"context"

	"github.com/google/uuid"
)

const createGrocery = `-- name: CreateGrocery :one
INSERT INTO grocery(name, category, default_quantity, default_price)
  VALUES ($1, $2, $3, $4)
RETURNING
  id, active, name, category, default_quantity, default_price, created
`

type CreateGroceryParams struct {
	Name            string        `json:"name"`
	Category        uuid.NullUUID `json:"category"`
	DefaultQuantity int16         `json:"default_quantity"`
	DefaultPrice    string        `json:"default_price"`
}

func (q *Queries) CreateGrocery(ctx context.Context, arg CreateGroceryParams) (Grocery, error) {
	row := q.db.QueryRowContext(ctx, createGrocery,
		arg.Name,
		arg.Category,
		arg.DefaultQuantity,
		arg.DefaultPrice,
	)
	var i Grocery
	err := row.Scan(
		&i.ID,
		&i.Active,
		&i.Name,
		&i.Category,
		&i.DefaultQuantity,
		&i.DefaultPrice,
		&i.Created,
	)
	return i, err
}

const deleteGrocery = `-- name: DeleteGrocery :one
UPDATE
  grocery
SET
  active = NOT active
WHERE
  id = $1
RETURNING
  id, active, name, category, default_quantity, default_price, created
`

func (q *Queries) DeleteGrocery(ctx context.Context, id uuid.UUID) (Grocery, error) {
	row := q.db.QueryRowContext(ctx, deleteGrocery, id)
	var i Grocery
	err := row.Scan(
		&i.ID,
		&i.Active,
		&i.Name,
		&i.Category,
		&i.DefaultQuantity,
		&i.DefaultPrice,
		&i.Created,
	)
	return i, err
}

const getGroceries = `-- name: GetGroceries :many
SELECT
  id, active, name, category, default_quantity, default_price, created
FROM
  grocery
WHERE
  active = TRUE
ORDER BY
  name DESC
LIMIT $1 OFFSET $2
`

type GetGroceriesParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetGroceries(ctx context.Context, arg GetGroceriesParams) ([]Grocery, error) {
	rows, err := q.db.QueryContext(ctx, getGroceries, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []Grocery
	for rows.Next() {
		var i Grocery
		if err := rows.Scan(
			&i.ID,
			&i.Active,
			&i.Name,
			&i.Category,
			&i.DefaultQuantity,
			&i.DefaultPrice,
			&i.Created,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const updateGrocery = `-- name: UpdateGrocery :one
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
  id, active, name, category, default_quantity, default_price, created
`

type UpdateGroceryParams struct {
	ID              uuid.UUID     `json:"id"`
	Name            string        `json:"name"`
	Category        uuid.NullUUID `json:"category"`
	DefaultQuantity int16         `json:"default_quantity"`
	DefaultPrice    string        `json:"default_price"`
}

func (q *Queries) UpdateGrocery(ctx context.Context, arg UpdateGroceryParams) (Grocery, error) {
	row := q.db.QueryRowContext(ctx, updateGrocery,
		arg.ID,
		arg.Name,
		arg.Category,
		arg.DefaultQuantity,
		arg.DefaultPrice,
	)
	var i Grocery
	err := row.Scan(
		&i.ID,
		&i.Active,
		&i.Name,
		&i.Category,
		&i.DefaultQuantity,
		&i.DefaultPrice,
		&i.Created,
	)
	return i, err
}