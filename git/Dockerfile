FROM ubuntu:22.04@sha256:0bced47fffa3361afa981854fcabcd4577cd43cebbb808cea2b1f33a3dd7f508

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
