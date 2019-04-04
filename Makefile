.PHONY: build deploy remove help echo
default: build

BRANCH = $(shell git symbolic-ref --short HEAD | cut -c1-10)
TICKET_NUMBER = $(shell echo $(BRANCH) | cut -c7- )

ifeq ($(BRANCH),master)
	STAGE = prod
	PREFIX = hello-prod
else ifeq ($(BRANCH),release)
	STAGE = qa
	PREFIX = hello-qa
else ifeq ($(BRANCH),develop)
	STAGE = develop
	PREFIX = hello-dev
else
	STAGE = dev
	PREFIX = "hello-$(TICKET_NUMBER)"
endif

##
### Docker targets
##
build:
	npm install

deploy: build echo ## Deploy Serverless Service
	serverless deploy \
		--verbose \
		--stage $(PREFIX) \
		--file $(STAGE) \
		--prefix $(PREFIX) \

remove: build ## Remove resources
	serverless remove \
		--verbose \
		--stage $(PREFIX) \
		--file $(STAGE)
		--prefix $(PREFIX) \

echo: ## Helpful way to see the makefile variables
	@printf "Stage: $(STAGE)\n"
	@printf "Prefix: $(PREFIX)\n"
	@printf "Branch: $(BRANCH)\n"
	