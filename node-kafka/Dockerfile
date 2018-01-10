FROM yolean/node

ENV NODE_PATH=/usr/local/lib/node_modules \
  NODE_RDKAFKA_VERSION=2.2.1 \
  SNAPPY_VERSION=5.0.5

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
  '; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  chown node ${NODE_PATH}; \
  su node -c "npm install -g node-rdkafka@${NODE_RDKAFKA_VERSION}  snappy@${SNAPPY_VERSION}"; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log; \
  \
  node -e "console.log(require('node-rdkafka').librdkafkaVersion)"; \
  node -e "console.log(require('node-rdkafka').features)";
