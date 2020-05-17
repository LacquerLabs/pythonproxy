.DEFAULT_GOAL := help

ORG = lacquerlabs
NAME = pythonproxy
IMAGENAME = $(ORG)/$(NAME)

build: ## Build the container image
	@docker build -t ${IMAGENAME}:latest .

rebuild: ## Build it without using cache
	@docker build --no-cache -t ${IMAGENAME}:latest .

buildwithmirror: ## Build the container image with pythonproxy running
	@docker build \
		--build-arg MIRROR_HOST=host.docker.internal \
		--build-arg MIRROR_URL=http://host.docker.internal:3141/root/mirror \
		-t ${IMAGENAME}:latest .

rebuildwithmirror: ## Build the containers
	@docker build \
		--build-arg MIRROR_HOST=host.docker.internal \
		--build-arg MIRROR_URL=http://host.docker.internal:3141/root/mirror \
		--no-cache -t ${IMAGENAME}:latest .

rundocker: ## Run the compose stack
	docker run -it lacquerlabs/pythonproxy:latest

initstorage: ## initalize the persistent storage
	@rm -rf ./persistent
	@mkdir ./persistent 
	@echo > ./persistent/.gitkeep

connect: ## connect to the running service
	docker-compose exec pythonproxy shell

kill: ## kill the running stack
	docker-compose kill

.PHONY: help

help: ## Helping devs since 2016
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "For additional commands have a look at the README"
