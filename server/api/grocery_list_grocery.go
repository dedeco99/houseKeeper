package api

import (
	"database/sql"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type getGroceryListGroceriesRequest struct {
	ID string `uri:"id" binding:"required"`
}

func (server *Server) getGroceryListGroceries(ctx *gin.Context) {
	var req getGroceryListGroceriesRequest

	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	uuid, err := uuid.Parse(req.ID)

	if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	groceryListGroceries, err := server.store.GetGroceryListGroceries(ctx, uuid)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, response("GET_GROCERY_LIST_GROCERIES", groceryListGroceries))
}

type deleteGroceryListGroceryRequest struct {
	ID string `uri:"id" binding:"required"`
}

func (server *Server) deleteGroceryListGrocery(ctx *gin.Context) {
	var req deleteGroceryListGroceryRequest

	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	uuid, err := uuid.Parse(req.ID)

	if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	groceryListGrocery, err := server.store.DeleteGroceryListGrocery(ctx, uuid)

	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}

		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, response("DELETE_GROCERY_LIST_GROCERY", groceryListGrocery))
}
