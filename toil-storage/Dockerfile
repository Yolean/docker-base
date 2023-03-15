# syntax=docker/dockerfile:1.4

FROM --platform=$TARGETPLATFORM yolean/toil as toil

FROM --platform=$TARGETPLATFORM yolean/docker-base

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps=' \
    ca-certificates curl \
    jq \
  '; \
  buildDeps=' \
  '; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  [ -z "$buildDeps" ] || apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log /root/.gnupg;

COPY --from=toil /usr/local/src/ystack/bin/y-rpk-v* /usr/local/bin/rpk
COPY --from=toil /usr/local/bin/mc /usr/local/bin/
