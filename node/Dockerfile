FROM --platform=$TARGETPLATFORM node:18.14.2-bullseye-slim@sha256:81b43146e32b3704663eb243d092b82592eab50f683498c5db9bda07d4ee7e46

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]

RUN chmod g+w /usr/src && chgrp nogroup /usr/src

RUN corepack enable && corepack prepare yarn@4.0.0-rc.36 && corepack prepare pnpm@7.26.0
