FROM solsson/kafka:native-cli@sha256:16813cae4712b1b3933a4205850300043193f2932b0de4603d9bc07da2dcf033 as kafka-cli

FROM liftm/kafkacat@sha256:0845a52f6c9c8f96042ba64c67dd16b216820ab8f92e05552d9664e8ad3550c2 as kafkacat-static

FROM grafana/logcli:2.3.0-amd64@sha256:ba1d4380e621b079647f88622e1c2f2d40181e514a1d93167de0299aa8d4302c as logcli

FROM minio/mc:RELEASE.2021-07-27T06-46-19Z@sha256:4ee74e7e471a39bc695907b7a4f06ae273fd660a1d919253308d1f0566de7a14 as mc

FROM yolean/builder-base as apt

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

FROM yolean/builder-base

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'

COPY --from=apt \
  /usr/lib/x86_64-linux-gnu/libbsd.so.* \
  /usr/lib/x86_64-linux-gnu/libedit.so.* \
  /usr/lib/x86_64-linux-gnu/libdns.so.* \
  /usr/lib/x86_64-linux-gnu/libirs.so.* \
  /usr/lib/x86_64-linux-gnu/libbind9.so.* \
  /usr/lib/x86_64-linux-gnu/libisccfg.so.* \
  /usr/lib/x86_64-linux-gnu/libisc.so.* \
  /usr/lib/x86_64-linux-gnu/libjson-c.so.* \
  /usr/lib/x86_64-linux-gnu/libxml2.so.* \
  /usr/lib/x86_64-linux-gnu/libmaxminddb.so.* \
  /usr/lib/x86_64-linux-gnu/liblmdb.so.* \
  /usr/lib/x86_64-linux-gnu/libns.so.* \
  /usr/lib/x86_64-linux-gnu/libuv.so.* \
  /usr/lib/x86_64-linux-gnu/libicuuc.so.* \
  /usr/lib/x86_64-linux-gnu/libicudata.so.* \
  /usr/lib/x86_64-linux-gnu/
COPY --from=apt /usr/bin/nc* \
  /usr/bin/nslookup \
  /usr/bin/find \
  /usr/bin/xargs \
  /usr/bin/

COPY --from=kafka-cli /usr/local/bin /usr/local/bin
COPY --from=kafkacat-static / /usr
COPY --from=logcli /usr/bin/logcli /usr/local/bin/
COPY --from=mc /usr/bin/mc /usr/local/bin/

RUN set -e; \
  y-yq; \
  y-rpk;

RUN set -ex; \
  nslookup localhost; \
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
  kafkacat -V; \
  pwd && touch workspace-file && rm workspace-file
