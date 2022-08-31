FROM --platform=$TARGETPLATFORM node:18.8.0-bullseye-slim@sha256:12b15efcc41e137ca24d9a13acade91f67c8da3729be8af48dd1dd089d0046ce

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src
