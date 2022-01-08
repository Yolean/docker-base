FROM --platform=linux/amd64 solsson/kafka:native-cli@sha256:16813cae4712b1b3933a4205850300043193f2932b0de4603d9bc07da2dcf033 as kafka-cli

FROM --platform=linux/amd64 liftm/kafkacat:1.7.0@sha256:7545a6199bcbd07961fb8a2dee4ddee5e2e9556eaffc7324b126a7a6db6ffebb as kafkacat-static

# images above do not support arm64

FROM --platform=$TARGETPLATFORM grafana/logcli:2.4.1-amd64@sha256:c5243634a8586178ab29faefbbcb760d96615a8caab79d019c9c65966af49ce1 as logcli

FROM --platform=$TARGETPLATFORM minio/mc:RELEASE.2022-01-07T06-01-38Z@sha256:22cf686789cced8bfbb4643f82faf6b4ccc9b99a5b3ae0b395f0bd70fd815955 as mc

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
    /usr/lib/$PKG_PREFIX/libdns.so.* \
    /usr/lib/$PKG_PREFIX/libirs.so.* \
    /usr/lib/$PKG_PREFIX/libbind9.so.* \
    /usr/lib/$PKG_PREFIX/libisccfg.so.* \
    /usr/lib/$PKG_PREFIX/libisc.so.* \
    /usr/lib/$PKG_PREFIX/libjson-c.so.* \
    /usr/lib/$PKG_PREFIX/libxml2.so.* \
    /usr/lib/$PKG_PREFIX/libmaxminddb.so.* \
    /usr/lib/$PKG_PREFIX/liblmdb.so.* \
    /usr/lib/$PKG_PREFIX/libns.so.* \
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
