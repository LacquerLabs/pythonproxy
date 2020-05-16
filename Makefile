.DEFAULT_GOAL := help

build: ## Build the containers
	docker-compose pull && \
	docker-compose build --force-rm --parallel

rebuild: ## Build it without using cache
	docker-compose pull && \
	docker-compose build --force-rm --no-cache --pull --parallel

run: ## Run the compose stack
	helpers/docker_network.sh start && \
	docker-compose up --force-recreate

connect: ## connect to the running service
	docker-compose exec dockgo /bin/sh

kill: ## kill the running stack
	docker-compose kill

.PHONY: help

help: ## Helping devs since 2016
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "For additional commands have a look at the README"
