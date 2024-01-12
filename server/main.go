package main

import (
	"database/sql"
	"log"

	"github.com/dedeco99/housekeeper/api"
	db "github.com/dedeco99/housekeeper/db/sqlc"

	_ "github.com/lib/pq"
)

const (
	dbDriver      = "postgres"
	dbSource      = "postgresql://dedeco99@localhost:5432/housekeeper?sslmode=disable"
	serverAddress = "0.0.0.0:5001"
)

func main() {
	conn, err := sql.Open(dbDriver, dbSource)

	if err != nil {
		log.Fatal("cannot connect to db: ", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(serverAddress)

	if err != nil {
		log.Fatal("cannot start server: ", err)
	}
}
