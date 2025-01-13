FROM --platform=$TARGETPLATFORM node:23.6.0-bookworm-slim@sha256:bde350c38a1090c74566da2547da84727495efa663a0e6e314d31c49a89abd73

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

RUN chmod g+w /usr/src && chgrp nogroup /usr/src

ENV npm_config_update_notifier=false

ENTRYPOINT [ "/usr/local/bin/node" ]
WORKDIR /app
