FROM --platform=$TARGETPLATFORM node:22.13.1-bookworm-slim@sha256:d6d1b3a6f21a25e43d765816281b4a86e5f1ebf843cfae1b14dd0f1c28257cc7

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

RUN chmod g+w /usr/src && chgrp nogroup /usr/src

ENV npm_config_update_notifier=false

ENTRYPOINT [ "/usr/local/bin/node" ]
WORKDIR /app
