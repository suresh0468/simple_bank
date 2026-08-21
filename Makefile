-include app.env
DB_URL=$(DB_SOURCE)

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
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

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

composeup:
	docker compose up

composedown:
	docker compose down

proto:
	rm -f pb/*.go
	cd proto && protoc --go_out=../pb --go_opt=paths=source_relative \
	--go-grpc_out=../pb --go-grpc_opt=paths=source_relative \
	*.proto

evans:
	evans --host localhost --port 9090 -r repl

.PHONY: postgres createdb dropdb migrateup migrateup1 migratedown migratedown1 sqlc test testClean mock composeup composedown proto evans