FROM --platform=$TARGETPLATFORM yolean/runtime-quarkus-ubuntu-jre:root

ENV KAFKA_VERSION=3.1.0 SCALA_VERSION=2.13

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='ca-certificates netcat-openbsd'; \
  buildDeps='curl gnupg dirmngr'; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  curl -f -sLS -o KEYS https://www.apache.org/dist/kafka/KEYS; \
  gpg --import KEYS && rm KEYS; \
  \
  SCALA_BINARY_VERSION=$(echo $SCALA_VERSION | cut -f 1-2 -d '.'); \
  mkdir -p /opt/kafka; \
  curl -f -sLS -o kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz.asc https://www.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz.asc; \
  curl -f -sLS -o kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz "https://www-eu.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz"; \
  gpg --verify kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz.asc kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz; \
  tar xzf kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz --strip-components=1 -C /opt/kafka; \
  rm kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz; \
  \
  rm -rf /opt/kafka/site-docs; \
  mkdir /opt/kafka/logs && chgrp nogroup /opt/kafka/logs && chmod g+w /opt/kafka/logs; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

WORKDIR /opt/kafka
ENTRYPOINT [ "./bin/kafka-server-start.sh" ]
CMD [ "config/kraft/server.properties" ]
