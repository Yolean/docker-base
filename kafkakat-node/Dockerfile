FROM solsson/kafkacat-fixedkey@sha256:fb27acf4c7ca25eca6a6cffe145cb492ee4d4c87cba0459787fb43f8040f6d7b \
  as kafkcat-binary

FROM yolean/node@sha256:b16c9154c4e8851f2a1fc31a2da3609284ed2ad65dc15249f9ef9b49bed835fd

COPY --from=kafkcat-binary /usr/local/bin/kafkacat /usr/local/bin/kafkacat

RUN set -ex; \
  runtimeDeps='libssl1.1 libsasl2-2'; \
  export DEBIAN_FRONTEND=noninteractive; \
  apt-get update && apt-get install -y $runtimeDeps --no-install-recommends; \
  rm -rf /var/lib/apt/lists/*; \
  rm /var/log/dpkg.log /var/log/apt/*.log; \
  kafkacat -V
