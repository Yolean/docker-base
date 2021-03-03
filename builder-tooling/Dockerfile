FROM golang:1.16.0-buster@sha256:93fe51544ec5ee00e6c7ba45957cdf6b79fb3f09a8daefaf84de882f21980f15 as golang

FROM yolean/builder-base

USER root

RUN runtimeDeps='gcc' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

USER nonroot:nogroup

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin
