package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/suresh/simple_bank/api"
	db "github.com/suresh/simple_bank/db/sqlc"
)

const (
	dbDriver      = "postgres"
	dbSource      = "postgresql://suresh:2003@localhost:5432/simple_bank?sslmode=disable"
	serverAddress = "0.0.0.0:8081"
)

func main() {
	conn, err := sql.Open(dbDriver, dbSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(serverAddress)
	if err != nil {
		log.Fatal("cannot start server:", err)
	}
}
