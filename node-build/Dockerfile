FROM yolean/node

RUN runtimeDeps='make g++ python libsasl2-2 libsasl2-dev' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log
