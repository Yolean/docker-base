FROM --platform=$TARGETPLATFORM yolean/node-kafka:root

ENV KAFKA_CACHE_VERSION=Yolean/kafka-cache#4db623eee2faf25f5bfcd4f578822234f2b14aae

RUN set -ex; \
  su node -c "npm install -g --only=prod --ignore-scripts kafka-cache@${KAFKA_CACHE_VERSION}"; \
  \
  node -e "console.log(require('kafka-cache'))";
