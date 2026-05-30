package db

import (
	"database/sql"
	"log"
	"os"
	"testing"

	_ "github.com/lib/pq"
)

const (
	dbDriver = "postgres"
	dbSource = "postgresql://suresh:2003@localhost:5432/simple_bank?sslmode=disable"
)

var testQueries *Queries
var testStore *Store
var testDB *sql.DB

func TestMain(m *testing.M) {
	var err error
	testDB, err = sql.Open(dbDriver, dbSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	testStore = NewStore(testDB)
	testQueries = testStore.Queries

	os.Exit(m.Run())
}
