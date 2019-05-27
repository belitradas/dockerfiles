CURATOR_VERSION ?= 5.7.6

docker-build:
	docker build . --build-arg CURATOR_VERSION=$(CURATOR_VERSION) -t belitre/curator:$(CURATOR_VERSION)

docker-push:
	docker push belitre/curator:$(CURATOR_VERSION)
