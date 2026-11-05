FROM --platform=$TARGETPLATFORM node:26.13.0-trixie-slim@sha256:5adad64f9a1fca2d51972caa65983634c8a774eb300d72b20f7f2a0f60368072

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

RUN chmod g+w /usr/src && chgrp nogroup /usr/src

ENV npm_config_update_notifier=false

ENTRYPOINT [ "/usr/local/bin/node" ]
WORKDIR /app
