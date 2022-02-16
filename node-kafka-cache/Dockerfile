FROM --platform=$TARGETPLATFORM yolean/node-kafka:root

ENV KAFKA_CACHE_VERSION=Yolean/kafka-cache#a451bd3fc013925e7204b329fe50253c323e5374

RUN set -ex; \
  su node -c "npm install -g --only=prod --ignore-scripts kafka-cache@${KAFKA_CACHE_VERSION}"; \
  \
  node -e "console.log(require('kafka-cache'))";
