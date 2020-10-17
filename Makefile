all: docker
	@echo Ready to go!  Use "make apply" to start.

apply: docker
	kubectl apply -f k8s/namespace.yaml
	helm upgrade -i -n traefik-sandbox traefik traefik/traefik
	kubectl apply -f k8s/services.yaml
	kubectl apply -f k8s/routes.yaml

delete:
	kubectl delete -f k8s/routes.yaml || true
	kubectl delete -f k8s/services.yaml || true
	helm uninstall -n traefik-sandbox traefik || true
	kubectl delete -f k8s/namespace.yaml || true

bin:
	mkdir -p bin

bin/echo-server: bin ./cmd/echo/main.go
	CGO_ENABLED=0 go build -o bin/echo-server ./cmd/echo/main.go

bin/api-server: bin ./cmd/api/main.go
	CGO_ENABLED=0 go build -o bin/api-server ./cmd/api/main.go

docker: docker-echo docker-api

docker-echo:
	docker build -t traefik-sandbox-echo -f Dockerfile.echo .

docker-api:
	docker build -t traefik-sandbox-api -f Dockerfile.api .

test:
	@echo "Checking dashboard: http://traefik.localhost/dashboard/"
	curl -LH "Host: traefik.localhost" http://localhost/dashboard/
	@echo "Checking echo service: http://echo.localhost"
	curl -LH "Host: echo.localhost" http://localhost
	@echo "Checking echo service with extra url stuff: http://echo.localhost/xyz/32/?x=3"
	curl -LH "Host: echo.localhost" http://localhost/xyz/32/?x=3
	@echo "Checking API service: http://api.localhost"
	curl -LH "Host: api.localhost" http://localhost/dog/genji

