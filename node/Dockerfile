FROM --platform=$TARGETPLATFORM node:18.4.0-bullseye-slim@sha256:a9a76d0251242bc332862d16b905fd3aa9dd8ebc1f82d0c1565911d727eba3c5

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src
