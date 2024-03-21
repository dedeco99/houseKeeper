package api

import (
	"database/sql"
	"net/http"

	db "github.com/dedeco99/housekeeper/db/sqlc"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

func (server *Server) getGroceries(ctx *gin.Context) {
	groceries, err := server.store.GetGroceries(ctx)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, response("GET_GROCERIES", groceries))
}

type addGroceryRequest struct {
	Name            string `json:"name"`
	DefaultQuantity int    `json:"defaultQuantity"`
	DefaultPrice    string `json:"defaultPrice"`
}

func (server *Server) addGrocery(ctx *gin.Context) {
	var req addGroceryRequest

	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	var defaultPrice = "0"
	if req.DefaultPrice != "" {
		defaultPrice = req.DefaultPrice
	}

	arg := db.AddGroceryParams{
		Name:            req.Name,
		DefaultQuantity: int16(req.DefaultQuantity),
		DefaultPrice:    defaultPrice,
	}

	grocery, err := server.store.AddGrocery(ctx, arg)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))

		return
	}

	ctx.JSON(http.StatusCreated, response("ADD_GROCERY", grocery))
}

type editGroceryRequest struct {
	ID string `uri:"id" binding:"required"`

	Data struct {
		Name            string `json:"name"`
		DefaultQuantity int    `json:"defaultQuantity"`
		DefaultPrice    string `json:"defaultPrice"`
	}
}

func (server *Server) editGrocery(ctx *gin.Context) {
	var req editGroceryRequest

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

	var defaultPrice = "0"
	if req.Data.DefaultPrice != "" {
		defaultPrice = req.Data.DefaultPrice
	}

	arg := db.EditGroceryParams{
		ID:              uuid,
		Name:            req.Data.Name,
		DefaultQuantity: int16(req.Data.DefaultQuantity),
		DefaultPrice:    defaultPrice,
	}

	grocery, err := server.store.EditGrocery(ctx, arg)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))

		return
	}

	ctx.JSON(http.StatusOK, response("EDIT_GROCERY", grocery))
}

type deleteGroceryRequest struct {
	ID string `uri:"id" binding:"required"`
}

func (server *Server) deleteGrocery(ctx *gin.Context) {
	var req deleteGroceryRequest

	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	uuid, err := uuid.Parse(req.ID)

	if err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	grocery, err := server.store.DeleteGrocery(ctx, uuid)

	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}

		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, response("DELETE_GROCERY", grocery))
}
