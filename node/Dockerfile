FROM --platform=$TARGETPLATFORM node:16.15.0-bullseye-slim@sha256:14af3fc10c3b85be74621ae6f0066ee4b2ab1ae1d6c0c87e0ada9ca193346071

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src
