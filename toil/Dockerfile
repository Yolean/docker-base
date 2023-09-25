FROM --platform=linux/amd64 solsson/kafka:native-cli@sha256:16813cae4712b1b3933a4205850300043193f2932b0de4603d9bc07da2dcf033 as kafka-cli

FROM --platform=$TARGETPLATFORM liftm/kafkacat:1.7.0@sha256:8658c1fa53632764bfcc3f9fad3dbf8b1d1a74f05244cd3a0ce9825e3344dc98 as kafkacat-static

# images above do not support arm64

ARG TARGETARCH
FROM --platform=$TARGETPLATFORM grafana/logcli:2.9.1-$TARGETARCH as logcli

FROM --platform=$TARGETPLATFORM minio/mc:RELEASE.2023-09-22T05-07-46Z@sha256:814b17be3f895a51295113aecea806b83e74f25a3048dea443935f3dc066cd90 as mc

FROM --platform=$TARGETPLATFORM yolean/builder-base as apt

USER root
RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='netcat-openbsd dnsutils findutils bsdextrautils zip'; \
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
    /usr/bin/zip \
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
  zip --version | grep 'This is Zip'; \
  pwd && touch workspace-file && rm workspace-file
