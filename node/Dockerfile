FROM node:10.16.0-stretch-slim@sha256:9afe43a8f8944377272e5f000695cc350db8e723639a4a44cf6e5c96c8a0ac9f

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]
