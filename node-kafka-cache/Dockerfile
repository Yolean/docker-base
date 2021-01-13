FROM yolean/node-kafka

ENV KAFKA_CACHE_VERSION=Yolean/kafka-cache#1731c51ca8d0ae810c90f328c6fccf0abdd247ac

# There's no indication that libleveldb1d is used, it's here because we had build problems

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='libleveldb1d'; \
  buildDeps=' \
    build-essential \
    python \
    libleveldb-dev \
    git \
  '; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  su node -c "npm install -g --only=prod kafka-cache@${KAFKA_CACHE_VERSION}"; \
  rm -rf /home/node/.npm; \
  rm -rf /home/node/.node-gyp; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log; \
  \
  node -e "console.log(require('kafka-cache'))";
