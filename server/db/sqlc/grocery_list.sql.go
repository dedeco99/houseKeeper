// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.25.0
// source: grocery_list.sql

package db

import (
	"context"

	"github.com/google/uuid"
)

const createGroceryList = `-- name: CreateGroceryList :one
INSERT INTO grocery_list(name)
  VALUES ($1)
RETURNING
  id, active, name, created
`

func (q *Queries) CreateGroceryList(ctx context.Context, name string) (GroceryList, error) {
	row := q.db.QueryRowContext(ctx, createGroceryList, name)
	var i GroceryList
	err := row.Scan(
		&i.ID,
		&i.Active,
		&i.Name,
		&i.Created,
	)
	return i, err
}

const deleteGroceryList = `-- name: DeleteGroceryList :one
UPDATE
  grocery_list
SET
  active = NOT active
WHERE
  id = $1
RETURNING
  id, active, name, created
`

func (q *Queries) DeleteGroceryList(ctx context.Context, id uuid.UUID) (GroceryList, error) {
	row := q.db.QueryRowContext(ctx, deleteGroceryList, id)
	var i GroceryList
	err := row.Scan(
		&i.ID,
		&i.Active,
		&i.Name,
		&i.Created,
	)
	return i, err
}

const getGroceryLists = `-- name: GetGroceryLists :many
SELECT
  id, active, name, created
FROM
  grocery_list
WHERE
  active = TRUE
ORDER BY
  created DESC
`

func (q *Queries) GetGroceryLists(ctx context.Context) ([]GroceryList, error) {
	rows, err := q.db.QueryContext(ctx, getGroceryLists)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []GroceryList{}
	for rows.Next() {
		var i GroceryList
		if err := rows.Scan(
			&i.ID,
			&i.Active,
			&i.Name,
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

const updateGroceryList = `-- name: UpdateGroceryList :one
UPDATE
  grocery_list
SET
  name = $2
WHERE
  id = $1
RETURNING
  id, active, name, created
`

type UpdateGroceryListParams struct {
	ID   uuid.UUID `json:"id"`
	Name string    `json:"name"`
}

func (q *Queries) UpdateGroceryList(ctx context.Context, arg UpdateGroceryListParams) (GroceryList, error) {
	row := q.db.QueryRowContext(ctx, updateGroceryList, arg.ID, arg.Name)
	var i GroceryList
	err := row.Scan(
		&i.ID,
		&i.Active,
		&i.Name,
		&i.Created,
	)
	return i, err
}
