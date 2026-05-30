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

migratedown:
	migrate -path db/migration -database "postgresql://suresh:2003@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc: 
	sqlc generate

test:
	go test -v -cover ./...

testClean:
	go clean -testcache

.PHONY: postgres createdb dropdb migratedown migrateup	sqlc test testClean