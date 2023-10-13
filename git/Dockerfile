FROM --platform=$TARGETPLATFORM ubuntu:22.04@sha256:a9038002b9b29c77c93b1c562ca2bee51313c6f5208c8d90b91929db62e96930

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
