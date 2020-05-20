FROM solsson/kafka:native-cli@sha256:a0b5ad4251dc1f30b36b0d4c5d3409428945b36a2561ea282df37ea1221a1bf9 as kafka-cli

FROM ubuntu:20.04@sha256:8bce67040cd0ae39e0beb55bcb976a824d9966d2ac8d2e4bf6119b45505cee64

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='openssl ca-certificates git curl procps netcat-openbsd libsnappy1v5 liblz4-1 libzstd1 kafkacat jq'; \
  buildDeps=''; \
  apt-get update; \
  apt-get install -y --no-install-recommends $runDeps $buildDeps; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

WORKDIR /workspace

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'

COPY --from=kafka-cli /usr/local/bin/* /usr/local/bin/
COPY --from=kafka-cli bin bin

COPY --from=minio/mc:RELEASE.2020-05-16T01-44-37Z@sha256:7d366697e4aae107bd5a84e4bb35cb7b1da773210431c9fa10f038bfd7696d1c /usr/bin/mc /usr/local/bin/

RUN set -e; \
  curl -sLS -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64; \
  chmod a+x /usr/local/bin/jq

RUN set -e; \
  curl -sLS -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/3.1.2/yq_linux_amd64; \
  chmod a+x /usr/local/bin/yq

RUN set -e; \
  F=$(mktemp); \
  curl -SLs https://dl.k8s.io/v1.15.10/kubernetes-client-linux-amd64.tar.gz \
    | tee $F \
    | tar xzf - --strip-components=3 -C /usr/local/bin/; \
  echo "02037072280ca4697acc6ea9f75e8f21050b740268861cbd9d2aa0b811d7812527140ec48d6eda48bc2b42ac3bd13612efe44456bf7b178848b968b41addf7ab $F" \
    | sha512sum -c -; \
  rm $F

RUN echo 'nonroot:x:65532:65534:nonroot:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot
USER nonroot:nogroup

RUN set -ex; \
  kafka-topics 2>&1 | head -n 1; \
  kafka-configs 2>&1 | head -n 1; \
  kafka-consumer-groups 2>&1 | head -n 1; \
  openssl version; \
  curl --version; \
  mc --version; \
  jq --version; \
  yq --version; \
  kafkacat -V
