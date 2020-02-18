FROM node:12.16.0-buster-slim@sha256:3b170898208c629b47c4ffa80b8aa6b3194313f86d41ec1f38bac0266695c6d3

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]
