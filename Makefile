#
# Variables
#
NAME=$(shell basename $(PWD))
FILTERED_NAME=$(shell echo $(NAME) | tr -d '-')
STARTER=go
PORT=8080
NAMESPACE=default
GIT_PROTO=git@github.com
ORG=myspotontheweb
STARTER_URL=$(GIT_PROTO):$(ORG)/helm-$(STARTER)-starter.git
STARTER_HOME=$(HELM_HOME)/starters/$(STARTER)

#
# Command targets (not dependent on files)
#
.PHONY: generate clean clean-files clean-starter clean-all

#
# Default target
#
generate: chart Dockerfile .travis.yml

#
# File oriented targets
#
$(STARTER_HOME):
	git clone $(STARTER_URL) $@
	@rm -rf $@/.git

chart: $(STARTER_HOME)
	@helm create --starter=$(STARTER) $(FILTERED_NAME)
	@mv $(FILTERED_NAME) chart
	@sed --in-place "s/<PORT>/$(PORT)/g" chart/values.yaml

Dockerfile: chart/.ci/Dockerfile
	cat $< | envsubst '$NAME,$FILTERED_NAME,$NAMESPACE,$PORT' > $@

.travis.yml: chart/.ci/.travis.yml
	cat $< | envsubst '$NAME,$FILTERED_NAME,$NAMESPACE,$PORT' > $@

#
# Clean targets
#
clean-files:
	rm -rf chart
	rm -f Dockerfile
	rm -f .travis.yml

clean-starter:
	rm -rf $(STARTER_HOME)

clean-all: clean-files clean-starter

clean: clean-files

