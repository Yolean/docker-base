FROM yolean/node-kafka

ENV KAFKA_CACHE_VERSION=Yolean/kafka-cache#846d15066e11a69998f1489b34712400abbb7d53

# There's no indication that libleveldb1d is used, it's here because we had build problems

RUN set -ex; \
  su node -c "npm install -g --only=prod --ignore-scripts kafka-cache@${KAFKA_CACHE_VERSION}"; \
  \
  node -e "console.log(require('kafka-cache'))";
