FROM golang:1.16.2-buster@sha256:d360ee0586f29b6e5b5643085a1a4e8ae12ad482c45dca42e671d4c0526e3517 as golang

FROM yolean/builder-base

USER root

RUN runtimeDeps='gcc libc-dev' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

USER nonroot:nogroup

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin
