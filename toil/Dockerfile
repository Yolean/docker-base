FROM solsson/kafka:native-cli@ha256:16813cae4712b1b3933a4205850300043193f2932b0de4603d9bc07da2dcf033 as kafka-cli
USER root

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='openssl ca-certificates git curl procps netcat-openbsd jq'; \
  buildDeps=''; \
  apt-get update; \
  apt-get install -y --no-install-recommends $runDeps $buildDeps; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

WORKDIR /workspace

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'

COPY --from=minio/mc:RELEASE.2020-05-16T01-44-37Z@sha256:7d366697e4aae107bd5a84e4bb35cb7b1da773210431c9fa10f038bfd7696d1c /usr/bin/mc /usr/local/bin/

RUN set -e; \
  curl -sLS -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64; \
  chmod a+x /usr/local/bin/jq

RUN set -e; \
  curl -sLS -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/3.1.2/yq_linux_amd64; \
  chmod a+x /usr/local/bin/yq

RUN set -e; \
  F=$(mktemp); \
  curl -SLs https://dl.k8s.io/v1.17.9/kubernetes-client-linux-amd64.tar.gz \
    | tee $F \
    | tar xzf - --strip-components=3 -C /usr/local/bin/; \
  echo "57fe9caf9d40e8b3e9e1b58552af1b74bf3cdccb3bd50fb5e51ba95d3e08263dad831724d79f2b99c0d67b03a1e533667422a20ba4159234b3452cdffbb814d4 $F" \
    | sha512sum -c -; \
  rm $F

RUN chown nonroot .

RUN set -ex; \
  kafka-topics 2>&1 | head -n 1; \
  kafka-configs 2>&1 | head -n 1; \
  kafka-consumer-groups 2>&1 | head -n 1; \
  openssl version; \
  curl --version; \
  kubectl version --client=true; \
  mc --version; \
  jq --version; \
  yq --version; \
  kafkacat -V
