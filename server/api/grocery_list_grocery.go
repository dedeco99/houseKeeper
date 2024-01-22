package api

import (
	"database/sql"
	"net/http"
	"strings"

	db "github.com/dedeco99/housekeeper/db/sqlc"
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

type addGroceryListGroceryRequest struct {
	ID string `uri:"id" binding:"required"`

	Data struct {
		Grocery  string `json:"grocery"`
		Quantity int    `json:"quantity"`
		Price    string `json:"price"`
	}
}

func (server *Server) addGroceryListGrocery(ctx *gin.Context) {
	var req addGroceryListGroceryRequest

	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	if err := ctx.ShouldBindJSON(&req.Data); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	groceryListUUID, err := uuid.Parse(req.ID)
	groceryUUID, err2 := uuid.Parse(req.Data.Grocery)

	if err != nil || err2 != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	var price = "0"
	if req.Data.Price != "" {
		price = req.Data.Price
	}

	arg := db.AddGroceryListGroceryParams{
		GroceryList: groceryListUUID,
		Grocery:     groceryUUID,
		Quantity:    int16(req.Data.Quantity),
		Price:       price,
	}

	groceryListGrocery, err := server.store.AddGroceryListGrocery(ctx, arg)

	if err != nil {
		if strings.Contains(err.Error(), "duplicate key") {
			ctx.JSON(http.StatusConflict, errorResponse(err))
		} else {
			ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		}

		return
	}

	ctx.JSON(http.StatusCreated, response("ADD_GROCERY_LIST_GROCERY", groceryListGrocery))
}

type editGroceryListGroceryRequest struct {
	ID string `uri:"id" binding:"required"`

	Data struct {
		GroceryList string `json:"groceryList"`
		Quantity    int    `json:"quantity"`
		Price       string `json:"price"`
	}
}

func (server *Server) editGroceryListGrocery(ctx *gin.Context) {
	var req editGroceryListGroceryRequest

	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	if err := ctx.ShouldBindJSON(&req.Data); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	groceryListGroceryUUID, err := uuid.Parse(req.ID)
	groceryListUUID, err2 := uuid.Parse(req.Data.GroceryList)

	if err != nil || err2 != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	var price = "0"
	if req.Data.Price != "" {
		price = req.Data.Price
	}

	arg := db.EditGroceryListGroceryParams{
		ID:          groceryListGroceryUUID,
		GroceryList: groceryListUUID,
		Quantity:    int16(req.Data.Quantity),
		Price:       price,
	}

	groceryListGrocery, err := server.store.EditGroceryListGrocery(ctx, arg)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))

		return
	}

	ctx.JSON(http.StatusOK, response("EDIT_GROCERY_LIST_GROCERY", groceryListGrocery))
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
