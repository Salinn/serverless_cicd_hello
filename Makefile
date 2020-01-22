.PHONY: deploy remove help echo
default: deploy

BRANCH = $(shell git symbolic-ref --short HEAD | cut -c1-30)
TICKET_NUMBER = $(shell echo $(BRANCH) | cut -c7-10 )

ifeq ($(BRANCH),master)
	STAGE = prod
	API_GATEWAY_STAGE = "prod"
else ifeq ($(BRANCH),develop)
	STAGE = dev
	API_GATEWAY_STAGE = "dev"
else
	STAGE = "$(TICKET_NUMBER)"
	API_GATEWAY_STAGE = "dev"
endif


help:  ## Prints the names and descriptions of available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deploy: echo## Deploy Serverless Service
	serverless deploy \
		--verbose \
		--stage $(STAGE) \
		--apiGatewayStage $(API_GATEWAY_STAGE) 

remove: echo ## Remove resources
	serverless remove \
		--verbose \
		--stage $(STAGE) \
		--env $(ENV)

echo: ## Helpful way to see the makefile variables
	@printf "Stage: $(STAGE)\n"
	@printf "API_GATEWAY_STAGE: $(API_GATEWAY_STAGE)\n"
	@printf "Branch: $(BRANCH)\n"
	@printf "Ticket Number: $(TICKET_NUMBER)\n"