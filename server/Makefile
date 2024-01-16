sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server-dev:
	go run main.go

client-dev:
	cd ../client && flutter run --web-port 3005

.PHONY: sqlc test server-dev client-dev