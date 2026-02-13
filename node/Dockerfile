FROM --platform=$TARGETPLATFORM node:24.13.1-trixie-slim@sha256:1c78323e27e7aff8ac92377845119cd52ac3d3b22e197b3b14e8eb64af387f8c

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

RUN chmod g+w /usr/src && chgrp nogroup /usr/src

ENV npm_config_update_notifier=false

ENTRYPOINT [ "/usr/local/bin/node" ]
WORKDIR /app
