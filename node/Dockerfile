FROM node:16.9.1-buster-slim@sha256:af6f241029c4d63107c6ccbbd030c44d331786d724bd9c2e615edf46deab58e2

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src
