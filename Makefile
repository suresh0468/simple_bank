postgres:
	docker run --name postgres18 -p 5432:5432 -e POSTGRES_USER=suresh -e POSTGRES_PASSWORD=2003 -d postgres:18-alpine

postgresStart:
	docker start postgres18

postgresStop:
	docker stop postgres18

# Create a new database named simple_bank inside the postgres18 container
createdb: 
	docker exec -it postgres18 createdb --username=suresh --owner=suresh simple_bank

listdatabases:
	docker exec -it postgres18 psql -U suresh -l

# Delete the simple_bank database inside the postgres18 container
dropdb: 
	docker exec -it postgres18 dropdb --username=suresh simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://suresh:2003@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://suresh:2003@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://suresh:2003@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://suresh:2003@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc: 
	sqlc generate

test:
	go test -v -cover ./...

testClean:
	go clean -testcache

server:
	go run main.go

mock: 
	mockgen -package mockdb -destination db/mock/store.go github.com/suresh/simple_bank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migrateup1 migratedown migratedown1 sqlc test testClean mock