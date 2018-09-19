FROM alpine:3.8

ARG KS_VERSION=0.12.0
ARG HUB_VERSION=2.5.1
ARG ARCH=amd64

RUN apk --no-cache --update upgrade && \
    apk --no-cache --update add bash git wget

RUN wget "https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-${ARCH}-${HUB_VERSION}.tgz" && \
    tar xf "hub-linux-${ARCH}-${HUB_VERSION}.tgz" && \
    cp "hub-linux-${ARCH}-${HUB_VERSION}/bin/hub" /usr/bin/ && \
    chmod +x /usr/bin/hub && \
    rm -r hub-linux*

RUN wget "https://github.com/ksonnet/ksonnet/releases/download/v${KS_VERSION}/ks_${KS_VERSION}_linux_${ARCH}.tar.gz" && \
    tar xf "ks_${KS_VERSION}_linux_${ARCH}.tar.gz" && \
    cp "ks_${KS_VERSION}_linux_${ARCH}/ks" /usr/bin/ && \
    chmod +x /usr/bin/ks && \
    rm -r ks_*

