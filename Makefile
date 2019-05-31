
KUBECTL_VERSION ?= 1.14.2
GOX_VERSION ?= 1.0.0
GO_BUILDER_VERSION ?= 1.12.5
CURATOR_VERSION ?= 5.7.6

curator-build:
	docker build ./curator --build-arg CURATOR_VERSION=$(CURATOR_VERSION) -t belitre/curator:dev

curator-push:
	docker push belitre/curator:dev

kubectl-build:
	docker build ./kubectl --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) -t belitre/kubectl:dev

kubectl-push:
	docker push belitre/kubectl:dev

gobuilder-build:
	docker build ./gobuilder --build-arg GOX_VERSION=$(GOX_VERSION) -t belitre/gobuilder:dev

gobuilder-push:
	docker push belitre/gobuilder:dev

checkconfig-build:
	docker build ./checkconfig -t belitre/checkconfig:dev

checkconfig-push:
	docker push belitre/checkconfig:dev

checkconfig-fluentd-events:
	docker build ./fluentd-events -t belitre/fluentd-events:dev

checkconfig-fluentd-events:
	docker push belitre/fluentd-events:dev
