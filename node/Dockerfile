FROM --platform=$TARGETPLATFORM node:20.11.0-bookworm-slim@sha256:2f451571a2e424b7aed654ca404331bf1ebf1ae3b4794bef0618d123d7a670e4

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src

ENV npm_config_update_notifier=false
