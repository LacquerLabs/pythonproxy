.DEFAULT_GOAL := help

build: ## Build the container image
	@docker build \
		--build-arg MIRROR_HOST=host.docker.internal \
		--build-arg MIRROR_URL=http://host.docker.internal:3141/root/mirror \
		-t myapp:latest .

connect: ## connect to the running service
	docker-compose exec pythonproxy shell

kill: ## kill the running stack
	docker-compose kill

.PHONY: help

help: ## Helping devs since 2016
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "For additional commands have a look at the README"
