FROM golang:1.12.5

ARG GOX_VERSION=1.0.0

ENV GO111MODULE=on

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt update && apt-get install -y nodejs npm zip

RUN go get github.com/mitchellh/gox@v${GOX_VERSION}
