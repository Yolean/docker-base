FROM --platform=$TARGETPLATFORM ubuntu:22.04@sha256:6042500cf4b44023ea1894effe7890666b0c5c7871ed83a97c36c76ae560bb9b

RUN groupadd --gid 1000 git \
  && useradd --uid 1000 --gid git --shell /bin/bash --create-home git

RUN runtimeDeps='git ca-certificates' \
  && buildDeps='curl' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get purge -y --auto-remove $buildDeps \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

USER git:git
