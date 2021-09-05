FROM yolean/node

ENV NODE_PATH=/usr/local/lib/node_modules \
  NODE_RDKAFKA_VERSION=v2.11.0 \
  LIBRDKAFKA_VERSION=v1.6.1 \
  SEMVER_VERSION=7.3.5 \
  SNAPPY_VERSION=6.3.5

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='libssl1.1 libsasl2-2 zlib1g libsnappy1v5 liblz4-1 libzstd1'; \
  buildDeps=' \
    build-essential \
    python \
    libsasl2-dev \
    libssl-dev \
    zlib1g-dev \
    libsnappy-dev \
    liblz4-dev \
    libzstd-dev \
    git \
  '; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  chown node ${NODE_PATH}; \
  su node -c "npm install -g --only=prod snappy@${SNAPPY_VERSION}"; \
  \
  mkdir $NODE_PATH/node-rdkafka; \
  cd $NODE_PATH/node-rdkafka; \
  curl -sLS https://github.com/Blizzard/node-rdkafka/archive/$NODE_RDKAFKA_VERSION.tar.gz | tar xvz --strip-components=1; \
  (cd ./deps/librdkafka; curl -sLS https://github.com/edenhill/librdkafka/archive/$LIBRDKAFKA_VERSION.tar.gz | tar xvz --strip-components=1); \
  chown -R node .; \
  su node -c "npm install --only=prod --ignore-scripts"; \
  su node -c "npm run install"; \
  \
  rm -rf /home/node/.npm; \
  rm -rf /home/node/.node-gyp; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log; \
  \
  node -e "console.log(require('node-rdkafka').librdkafkaVersion)"; \
  node -e "console.log(require('node-rdkafka').features)";
