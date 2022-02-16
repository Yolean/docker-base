FROM --platform=$TARGETPLATFORM yolean/node-kafka

ENV KAFKA_CACHE_VERSION=Yolean/kafka-cache#a451bd3fc013925e7204b329fe50253c323e5374

# There's no indication that libleveldb1d is used, it's here because we had build problems

RUN set -ex; \
  su node -c "npm install -g --only=prod --ignore-scripts kafka-cache@${KAFKA_CACHE_VERSION}"; \
  \
  node -e "console.log(require('kafka-cache'))";
