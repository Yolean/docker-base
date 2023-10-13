FROM --platform=$TARGETPLATFORM node:18.18.1-bookworm-slim@sha256:b9408f9f6cdb7435b662423bb933b6ca5766ef92bf94e92ed1b6e6a85af0eeeb

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src

ENV npm_config_update_notifier=false
