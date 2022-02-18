FROM --platform=$TARGETPLATFORM node:16.14.0-bullseye-slim@sha256:22841c8578ef743f8e517ae194bdd6688537364b4c929f61a140b37578365d6c

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src
