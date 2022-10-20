FROM --platform=$TARGETPLATFORM node:18.11.0-bullseye-slim@sha256:f916ff4bcfc6bbe6e3a4fa24f29109e7446e7bcd1d788066c7c45f705de95e69

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src
