FROM node:16.13.0-buster-slim@sha256:9ec1ff69c844f2de3a6a2180cd49ca75797d9f2a0fc52bb33c8a672fd0fe7e18

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src
