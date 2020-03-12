FROM yolean/node

ENV NODE_PATH=/usr/local/lib/node_modules \
  NODE_RDKAFKA_VERSION=Blizzard/node-rdkafka#640c4cea2b4467e9feb89c552845b0ceec2662a9 \
  SNAPPY_VERSION=6.2.3

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='libssl1.1 libsasl2-2'; \
  buildDeps=' \
    build-essential \
    python \
    libsasl2-dev \
    libssl-dev \
    zlib1g-dev \
    liblz4-dev \
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
