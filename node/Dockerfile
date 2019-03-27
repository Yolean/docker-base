FROM node:10.15.3-stretch-slim@sha256:5a48598688f771a9140fdef31585dbe67b313b1e29439cbd9b81ebb25aeca517

RUN runtimeDeps='procps git ca-certificates' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

CMD [ "node" ]
