FROM golang:1.16.4-buster@sha256:13f1917d4a9bb26eb6cd5b7ef4c1178edd2f43c877352df0996583dd4dfd93e7 as golang

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
