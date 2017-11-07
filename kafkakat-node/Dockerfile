FROM solsson/kafkacat-fixedkey@sha256:e23753bc0900e7b95d29f8c9cb05440eb27d854f367d407ce4ab2955093ad360 as kafkcat-binary

FROM yolean/node

COPY --from=kafkcat-binary /usr/local/bin/kafkacat /usr/local/bin/kafkacat

RUN set -ex; \
  runtimeDeps='libssl1.1 libsasl2-2'; \
  export DEBIAN_FRONTEND=noninteractive; \
  apt-get update && apt-get install -y $runtimeDeps --no-install-recommends; \
  rm -rf /var/lib/apt/lists/*; \
  rm /var/log/dpkg.log /var/log/apt/*.log; \
  kafkacat -V
