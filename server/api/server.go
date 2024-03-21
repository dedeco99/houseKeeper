package api

import (
	"github.com/gin-gonic/gin"

	db "github.com/dedeco99/housekeeper/db/sqlc"
)

type Server struct {
	store  *db.Store
	router *gin.Engine
}

func NewServer(store *db.Store) *Server {
	server := &Server{store: store}
	router := gin.Default()

	router.GET("/api/accounts/:id", server.getAccount)
	router.POST("/api/accounts", server.createAccount)

	router.GET("/api/groceries", server.getGroceries)
	router.POST("/api/groceries", server.addGrocery)
	router.PUT("/api/groceries/:id", server.editGrocery)
	router.DELETE("/api/groceries/:id", server.deleteGrocery)

	router.GET("/api/grocery_lists", server.getGroceryLists)
	router.POST("/api/grocery_lists", server.addGroceryList)

	router.GET("/api/grocery_lists/:id", server.getGroceryListGroceries)
	router.POST("/api/grocery_lists/:id", server.addGroceryListGrocery)
	router.PUT("/api/grocery_lists/groceries/:id", server.editGroceryListGrocery)
	router.DELETE("/api/grocery_lists/groceries/:id", server.deleteGroceryListGrocery)

	server.router = router

	return server
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func response(message string, data any) gin.H {
	return gin.H{"message": message, "data": data}
}

func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}
