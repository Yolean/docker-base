FROM yolean/node

ENV NODE_PATH=/usr/local/lib/node_modules \
  NODE_RDKAFKA_VERSION=4885043477f5e595a584edf6b37b93233d71bb7a \
  SNAPPY_VERSION=6.3.5

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='libssl1.1 libsasl2-2 libsnappy1v5 liblz4-1 libzstd1'; \
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
  su node -c "npm install -g --only=prod node-rdkafka@${NODE_RDKAFKA_VERSION} snappy@${SNAPPY_VERSION}"; \
  rm -rf /home/node/.npm; \
  rm -rf /home/node/.node-gyp; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log; \
  \
  node -e "console.log(require('node-rdkafka').librdkafkaVersion)"; \
  node -e "console.log(require('node-rdkafka').features)";
