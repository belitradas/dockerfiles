FROM alpine:3.9.4

ARG KUBECTL_VERSION=1.14.2

# https://aur.archlinux.org/packages/kubectl-bin/
ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl

ENV HOME=/home/prow

RUN set -x && \
    apk add --no-cache curl ca-certificates make bash && \
    chmod +x /usr/local/bin/kubectl && \
    adduser prow -Du 2342 -h /config && \
    kubectl version --client

USER prow