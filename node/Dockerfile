FROM --platform=$TARGETPLATFORM node:18.12.0-bullseye-slim@sha256:0a621cdd7d66ad8976f4246ab0661e3b1dd0d397c1dd784ea01bf740bd1c2522

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src
