FROM --platform=$TARGETPLATFORM node:18.12.1-bullseye-slim@sha256:78e6da5da446d42872eb5c21bb651e478b01613475b321ce9e25e392dd876fff

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src

RUN corepack enable && corepack prepare yarn@4.0.0-rc.27 --activate
