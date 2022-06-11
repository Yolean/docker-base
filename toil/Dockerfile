FROM --platform=linux/amd64 solsson/kafka:native-cli@sha256:16813cae4712b1b3933a4205850300043193f2932b0de4603d9bc07da2dcf033 as kafka-cli

FROM --platform=$TARGETPLATFORM liftm/kafkacat:latest@sha256:6f772090bfbd3dfaec7d5685dc5af10d87fffc92ef5a79c4b7fe60f883281a03 as kafkacat-static

# images above do not support arm64

ARG TARGETARCH
FROM --platform=$TARGETPLATFORM grafana/logcli:2.5.0-$TARGETARCH as logcli

FROM --platform=$TARGETPLATFORM minio/mc:RELEASE.2022-06-10T22-29-12Z@sha256:b15adbe4a9b5de7d4411524a9505befaad071f78267a045feacbb2b9f7b9963b as mc

FROM --platform=$TARGETPLATFORM yolean/builder-base as apt

USER root
RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='netcat-openbsd dnsutils findutils'; \
  buildDeps=''; \
  apt-get update; \
  apt-get install -y --no-install-recommends $runDeps $buildDeps; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

RUN set -e; \
  PKG_PREFIX="$(uname -m)-linux-gnu"; \
  mkdir -p /opt/toil/lib/$PKG_PREFIX /opt/toil/bin; \
  cp -dav \
    /usr/lib/$PKG_PREFIX/libbsd.so.* \
    /usr/lib/$PKG_PREFIX/libedit.so.* \
    /usr/lib/$PKG_PREFIX/libmd.so.* \
    /usr/lib/$PKG_PREFIX/libdns-*-Ubuntu.so \
    /usr/lib/$PKG_PREFIX/libirs-*-Ubuntu.so \
    /usr/lib/$PKG_PREFIX/libbind9-*-Ubuntu.so \
    /usr/lib/$PKG_PREFIX/libns-*-Ubuntu.so \
    /usr/lib/$PKG_PREFIX/libisc-*-Ubuntu.so \
    /usr/lib/$PKG_PREFIX/libisccfg-*-Ubuntu.so \
    /usr/lib/$PKG_PREFIX/libjson-c.so.* \
    /usr/lib/$PKG_PREFIX/libxml2.so.* \
    /usr/lib/$PKG_PREFIX/libmaxminddb.so.* \
    /usr/lib/$PKG_PREFIX/liblmdb.so.* \
    /usr/lib/$PKG_PREFIX/libuv.so.* \
    /usr/lib/$PKG_PREFIX/libicuuc.so.* \
    /usr/lib/$PKG_PREFIX/libicudata.so.* \
    /opt/toil/lib/$PKG_PREFIX/; \
  cp \
    /usr/bin/nc* \
    /usr/bin/nslookup \
    /usr/bin/find \
    /usr/bin/xargs \
    /opt/toil/bin/;

# TODO verify that symlinks are preserved
#RUN ls -l /opt/toil/lib/$(uname -m)-linux-gnu/libxml2* && false

FROM --platform=$TARGETPLATFORM yolean/builder-base

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'

COPY --from=apt /opt/toil /usr/

# TODO verify that symlinks are preserved
#RUN ls -l /usr/lib/$(uname -m)-linux-gnu/libxml2* && false

COPY --from=kafka-cli /usr/local/bin /usr/local/bin
COPY --from=kafkacat-static / /usr/local
COPY kafkacat /usr/local/bin/kafkacat
COPY --from=logcli /usr/bin/logcli /usr/local/bin/
COPY --from=mc /usr/bin/mc /usr/local/bin/

RUN set -e; \
  y-yq; \
  y-rpk;

RUN set -ex; \
  find /usr/bin -name find; \
  kafka-topics 2>&1 | head -n 1; \
  kafka-topics_ifnotexists 2>&1 | head -n 1; \
  kafka-configs 2>&1 | head -n 1; \
  kafka-consumer-groups 2>&1 | head -n 1; \
  openssl version; \
  curl --version; \
  kubectl version --client=true; \
  mc --version; \
  jq --version; \
  yq --version; \
  logcli --version; \
  pwd && touch workspace-file && rm workspace-file
