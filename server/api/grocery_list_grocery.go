package api

import (
	"database/sql"
	"net/http"
	"strconv"
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

type createGroceryListGroceryRequest struct {
	ID string `uri:"id" binding:"required"`

	Data struct {
		Grocery  string `json:"grocery"`
		Quantity string `json:"quantity"`
		Price    string `json:"price"`
	}
}

func (server *Server) createGroceryListGrocery(ctx *gin.Context) {
	var req createGroceryListGroceryRequest

	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	if err := ctx.ShouldBindJSON(&req.Data); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))

		return
	}

	listUUID, err := uuid.Parse(req.ID)
	groceryUUID, err2 := uuid.Parse(req.Data.Grocery)

	if err != nil || err2 != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	var quantity int = 1
	if req.Data.Quantity != "" {
		quantityInt, err := strconv.Atoi(req.Data.Quantity)

		if err != nil {
			ctx.JSON(http.StatusBadRequest, errorResponse(err))
			return
		}

		quantity = quantityInt
	}

	var price = "0"
	if req.Data.Price != "" {
		price = req.Data.Price
	}

	arg := db.CreateGroceryListGroceryParams{
		GroceryList: listUUID,
		Grocery:     groceryUUID,
		Quantity:    int16(quantity),
		Price:       price,
	}

	groceryListGrocery, err := server.store.CreateGroceryListGrocery(ctx, arg)

	if err != nil {
		if strings.Contains(err.Error(), "duplicate key") {
			arg := db.UpdateGroceryListGroceryParams{
				Grocery:  groceryUUID,
				Quantity: int16(quantity),
				Price:    price,
			}

			groceryListGrocery, err := server.store.UpdateGroceryListGrocery(ctx, arg)

			if err != nil {
				ctx.JSON(http.StatusInternalServerError, errorResponse(err))
			} else {
				ctx.JSON(http.StatusOK, response("UPDATE_GROCERY_LIST_GROCERY", groceryListGrocery))
			}

			return
		} else {
			ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		}

		return
	}

	ctx.JSON(http.StatusCreated, response("CREATE_GROCERY_LIST_GROCERY", groceryListGrocery))

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
