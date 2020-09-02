# Makefile
#
# Include Makefile.aws if it exists.

AWS_INCLUDE := $(wildcard Makefile.aws)
ifneq ($(strip $(AWS_INCLUDE)),)
  include Makefile.aws
endif

default:
	echo $(AWS_INCLUDE)
	@echo Useful make Targets:
	@echo
	@echo "  clean        - Deletes intermediate files"
	@echo "  test         - Runs local unit tests"
	@echo "  deploy-Dev   - Deploys to Dev environment"
	@echo "  deploy-Prod  - Deploys to Prod environment"
	@echo "  delete-stack - Deletes the stack from AWS"
	@echo
	@echo By default, the stack name is "Scratch" -- you
	@echo can change this by using the STACKNAME variable.
	@echo To deploy to an AWS environment, you specify
	@echo which environment with the STAGENAME variable.
	@echo
	@echo For example, to deploy to Scratch Dev, you would
	@echo issue this command:
	@echo "  make deploy-Dev STACKNAME=Scratch STAGENAME=Dev"
	@echo
	@echo To deploy to Scratch Qa, use this command:
	@echo "  make deploy-Qa STACKNAME=Scratch STAGENAME=Qa"
	@echo

deploy-$(STAGENAME): package-lock.json .aws-sam
	sam deploy --template-file template.yaml \
    --stack-name $(STACKNAME)-$(STAGENAME) \
    --region $(REGION) --s3-bucket $(S3BUCKET) \
    --s3-prefix $(S3PREFIX) \
    --capabilities $(CAPABILITIES) \
    --parameter-overrides StageName=$(STAGENAME) StackName=$(STACKNAME)-$(STAGENAME)

clean:
	$(RM) -r .aws-sam node-modules package-lock.json

package-lock.json:
	npm install

.aws-sam: template.yaml package-lock.json
	sam build --template template.yaml --region $(REGION)

delete-stack:
	aws cloudformation delete-stack \
    --stack-name $(STACKNAME)-$(STAGENAME) \
    --region $(REGION) > /dev/null

