FROM --platform=$TARGETPLATFORM node:18.15.0-bullseye-slim@sha256:7d67f2765f8d1b13f3833001bebbc6513581ef3f300aa4b1019a0b6dff2c0b25

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src

ENV npm_config_update_notifier=false
