FROM solsson/kafkacat@sha256:2c539e4f58960ab7872976ebc664dd92de18cf27e7cbbeb296d654a2351f6ca4 \
  as kafkcat-binary

FROM yolean/node@sha256:230b269710a1d09b9ebbdeeea0fc4e69ac1388ab71b0178452e817065f69c700

COPY --from=kafkcat-binary /usr/local/bin/kafkacat /usr/local/bin/kafkacat

RUN set -ex; \
  runtimeDeps='libssl1.1 libsasl2-2'; \
  export DEBIAN_FRONTEND=noninteractive; \
  apt-get update && apt-get install -y $runtimeDeps --no-install-recommends; \
  rm -rf /var/lib/apt/lists/*; \
  rm /var/log/dpkg.log /var/log/apt/*.log; \
  kafkacat -V
