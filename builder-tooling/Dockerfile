FROM golang:1.16.5-buster@sha256:ff1931f625a79c1030d01979d8a70fa31a78d3827a69fc48f403cd5d8dbf9861 as golang

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
