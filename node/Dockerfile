FROM --platform=$TARGETPLATFORM node:26.8.2-trixie-slim@sha256:f7bb8247fdb16250dbec7fd0e24f091c6f5f0a29d256f3aef5816a7a369166b2

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

RUN chmod g+w /usr/src && chgrp nogroup /usr/src

ENV npm_config_update_notifier=false

ENTRYPOINT [ "/usr/local/bin/node" ]
WORKDIR /app
