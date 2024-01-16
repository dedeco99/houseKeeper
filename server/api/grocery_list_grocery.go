package api

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type getGroceryListGroceriesRequest struct {
	ID string `uri:"id" binding:"required"`
}

func (server *Server) GetGroceryListGroceries(ctx *gin.Context) {
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
	fmt.Println(groceryListGroceries)
	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}

		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, response("GET_GROCERY_LIST_GROCERIES", groceryListGroceries))
}
