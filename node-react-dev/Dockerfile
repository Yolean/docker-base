FROM node:10.16.3-buster-slim@sha256:043bc1cd3f8ed6abeefa14e2a60a97433f589876e776c194d0b19121b20a2473

RUN runtimeDeps='procps git curl ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

# basically npx create-react-app@3.1.1 my-app
RUN set -e; \
  mkdir -p /usr/src/app; \
  cd /usr/src/app; \
  npm install react@16.9.0 react-dom@16.9.0 react-scripts@3.1.1
