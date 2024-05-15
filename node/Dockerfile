FROM --platform=$TARGETPLATFORM node:20.13.1-bookworm-slim@sha256:cffed8cd39d6a380434e6d08116d188c53e70611175cd5ec7700f93f32a935a6

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src

ENV npm_config_update_notifier=false
