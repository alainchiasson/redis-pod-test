.DEFAULT_GOAL := help
.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

load:  ## Load the testscript in the config map
	kubectl create -f config.yml

reload: ## to update the scrip in the config map.
	kubectl replace -f config.yml

deploy:  ## Deploy the redis test to kubernetes
	kubectl create -f deploy.yml

delete: ## Delete the deploymnet
	kubectl delete deploymnet redis-test

clean:  ## removes everything from kubernetes
	kubectl delete deploymnet redis-test
	kubectl delete configmap runscript

show: ## Shows the deployment and pod status
	kubectl describe pods -l app=redis-test && kubectl get pods -l app=redis-test
