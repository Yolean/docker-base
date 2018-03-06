FROM yolean/node-kafka

ENV KAFKA_CACHE_VERSION=1.1.1

RUN set -ex; \
  \
  chown node ${NODE_PATH}; \
  su node -c "npm install -g kafka-cache@${KAFKA_CACHE_VERSION}"; \
  rm -rf /home/node/.npm; \
  rm -rf /home/node/.node-gyp;
