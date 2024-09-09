package api

import (
	"database/sql"
	"net/http"

	db "github.com/dedeco99/housekeeper/db/sqlc"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

func (server *Server) getGroceryCategories(ctx *gin.Context) {
	groceryCategories, err := server.store.GetGroceryCategories(ctx)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, response("GET_GROCERY_CATEGORIES", groceryCategories))
}

type addGroceryCategoryRequest struct {
	Name string `json:"name"`
}

func (server *Server) addGroceryCategory(ctx *gin.Context) {
	var req addGroceryCategoryRequest

	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	grocery, err := server.store.AddGroceryCategory(ctx, req.Name)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))

		return
	}

	ctx.JSON(http.StatusCreated, response("ADD_GROCERY_CATEGORY", grocery))
}

type editGroceryCategoryRequest struct {
	ID string `uri:"id" binding:"required"`

	Data struct {
		Name string `json:"name"`
	}
}

func (server *Server) editGroceryCategory(ctx *gin.Context) {
	var req editGroceryCategoryRequest

	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	if err := ctx.ShouldBindJSON(&req.Data); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	uuid, err := uuid.Parse(req.ID)

	if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	arg := db.EditGroceryCategoryParams{
		ID:   uuid,
		Name: req.Data.Name,
	}

	grocery, err := server.store.EditGroceryCategory(ctx, arg)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))

		return
	}

	ctx.JSON(http.StatusOK, response("EDIT_GROCERY_CATEGORY", grocery))
}

type deleteGroceryCategoryRequest struct {
	ID string `uri:"id" binding:"required"`
}

func (server *Server) deleteGroceryCategory(ctx *gin.Context) {
	var req deleteGroceryCategoryRequest

	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	uuid, err := uuid.Parse(req.ID)

	if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	grocery, err := server.store.DeleteGroceryCategory(ctx, uuid)

	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}

		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, response("DELETE_GROCERY_CATEGORY", grocery))
}
