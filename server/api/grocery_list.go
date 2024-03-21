package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (server *Server) getGroceryLists(ctx *gin.Context) {
	groceryLists, err := server.store.GetGroceryLists(ctx)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, response("GET_GROCERY_LISTS", groceryLists))
}

type addGroceryListRequest struct {
	Name string `json:"name" binding:"required"`
}

func (server *Server) addGroceryList(ctx *gin.Context) {
	var req addGroceryListRequest

	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	groceryList, err := server.store.AddGroceryList(ctx, req.Name)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusCreated, response("ADD_GROCERY_LIST", groceryList))
}
