FROM solsson/kafkacat@sha256:2c539e4f58960ab7872976ebc664dd92de18cf27e7cbbeb296d654a2351f6ca4

RUN set -ex; \
  runDeps='curl ca-certificates jq'; \
  buildDeps=''; \
  export DEBIAN_FRONTEND=noninteractive; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt

ENTRYPOINT [ "/bin/bash" ]
