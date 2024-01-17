package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (server *Server) getGroceries(ctx *gin.Context) {
	groceries, err := server.store.GetGroceries(ctx)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, response("GET_GROCERIES", groceries))
}
