FROM debian:stretch-slim@sha256:b4c6e46603728bdc550c9075be78439c45a0d509008770ad3775d097f28b6cca

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
