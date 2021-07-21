FROM golang:1.16.6-buster@sha256:777d13e40bc15456dceac9b37f926bd7b4c237645da9ff8e3c94d7a4916a909b as golang

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
