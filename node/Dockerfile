FROM node:12.16.1-buster-slim@sha256:fa7e3e05b62b9cfd417e153cfc1ab917744dfc5bb97f540197af99dc660be058

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]
