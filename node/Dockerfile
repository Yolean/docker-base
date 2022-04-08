FROM --platform=$TARGETPLATFORM node:16.14.2-bullseye-slim@sha256:84166838030b78441db7c90e0407cee1da736157a70f398b6589ea1f4ffa753a

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src
