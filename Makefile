
KUBECTL_VERSION ?= 1.14.2
GOX_VERSION ?= 1.0.0
GO_BUILDER_VERSION ?= 1.12.5

kubectl-build:
	docker build ./kubectl --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) -t belitre/kubectl:$(KUBECTL_VERSION)

kubectl-push:
	docker push belitre/kubectl:$(KUBECTL_VERSION)

gobuilder-build:
	docker build ./gobuilder --build-arg GOX_VERSION=$(GOX_VERSION) -t belitre/gobuilder:$(GO_BUILDER_VERSION)

gobuilder-push:
	docker push belitre/gobuilder:$(GO_BUILDER_VERSION)

checkconfig-build:
	docker build ./checkconfig -t belitre/checkconfig:latest

checkconfig-push:
	docker push belitre/checkconfig:latest

checkconfig-fluentd-events:
	docker build ./fluentd-events -t belitre/fluentd-events:latest

checkconfig-fluentd-events:
	docker push belitre/fluentd-events:latest