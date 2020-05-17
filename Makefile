.DEFAULT_GOAL := help

ORG = lacquerlabs
NAME = pythonproxy
IMAGENAME = $(ORG)/$(NAME)

build: ## Build the containers
	@docker build -t ${IMAGENAME}:latest .

rebuild: ## Build it without using cache
	@docker build --no-cache -t ${IMAGENAME}:latest .

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
