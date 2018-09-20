FROM ubuntu:16.04

ARG KS_VERSION=0.12.0
ARG HUB_VERSION=2.5.1
ARG ARCH=amd64

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git wget

RUN wget "https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-${ARCH}-${HUB_VERSION}.tgz" && \
    tar xf "hub-linux-${ARCH}-${HUB_VERSION}.tgz" && \
    mv "hub-linux-${ARCH}-${HUB_VERSION}/bin/hub" /usr/bin/hub && \
    chmod +x /usr/bin/hub && \
    rm -r hub-linux*

RUN wget "https://github.com/ksonnet/ksonnet/releases/download/v${KS_VERSION}/ks_${KS_VERSION}_linux_${ARCH}.tar.gz" && \
    tar xf "ks_${KS_VERSION}_linux_${ARCH}.tar.gz" && \
    mv "ks_${KS_VERSION}_linux_${ARCH}/ks" /usr/bin/ks && \
    chmod +x /usr/bin/ks && \
    rm -r ks_*

COPY src/main.sh /bin/main.sh

RUN chmod +x /bin/main.sh

ENTRYPOINT /bin/main.sh
