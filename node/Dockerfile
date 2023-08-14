FROM --platform=$TARGETPLATFORM node:18.17.1-bullseye-slim@sha256:b5846dae07bfe20bd6863c51b3b8745efc7433671bfc5ac46f98f3ae684f5b1f

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src

ENV npm_config_update_notifier=false
