.PHONY: deploy remove help echo
default: deploy

BRANCH = $(shell git symbolic-ref --short HEAD | cut -c1-10)
TICKET_NUMBER = $(shell echo $(BRANCH) | cut -c7- )

ifeq ($(BRANCH),master)
	STAGE = hello-prod
	ENV = prod
else ifeq ($(BRANCH),release)
	STAGE = hello-qa
	ENV = qa
else ifeq ($(BRANCH),develop)
	STAGE = hello-develop
	ENV = develop
else
	STAGE = "hello-$(TICKET_NUMBER)"
	ENV = dev
endif

deploy: echo ## Deploy Serverless Service
	serverless deploy \
		--verbose \
		--stage $(STAGE) \
		--env $(ENV) \

remove: echo ## Remove resources
	serverless remove \
		--verbose \
		--stage $(STAGE) \
		--env $(STAGE)

echo: ## Helpful way to see the makefile variables
	@printf "Stage: $(STAGE)\n"
	@printf "Env: $(ENV)\n"
	@printf "Branch: $(BRANCH)\n"
	@printf "Ticket Number: $(TICKET_NUMBER)\n"