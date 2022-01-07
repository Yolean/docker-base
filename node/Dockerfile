FROM --platform=$TARGETPLATFORM node:16.13.1-bullseye-slim@sha256:b0a27877c45f2d31d54a6197bcca1bbd1e307a557b1f655c8fbe80170567ca3e

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src
