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

	router.GET("/api/groceries/lists", server.getGroceryLists)
	router.POST("/api/groceries/lists", server.createGroceryList)

	router.GET("/api/groceries/lists/:id", server.getGroceryListGroceries)

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
