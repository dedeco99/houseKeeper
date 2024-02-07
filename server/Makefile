sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server-dev:
	go run main.go

client-dev:
	cd ../client && flutter run --web-port 3005

client-outdated:
	cd ../client && flutter pub outdated

client-upgrade:
	cd ../client && flutter pub upgrade --major-versions

client-lint:
	cd ../client && dart fix --apply

.PHONY: sqlc test server-dev client-dev