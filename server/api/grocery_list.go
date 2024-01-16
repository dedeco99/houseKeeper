package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (server *Server) GetGroceryLists(ctx *gin.Context) {
	groceryList, err := server.store.GetGroceryLists(ctx)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, response("GET_GROCERY_LIST", groceryList))
}
