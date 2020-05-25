FROM solsson/kafka:native-cli@sha256:68b74c11c232bc238701fad9c3fb6cf5c7ebd61f425ae7d91b08b0b772c448c1 as kafka-cli
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
  curl -SLs https://dl.k8s.io/v1.17.5/kubernetes-client-linux-amd64.tar.gz \
    | tee $F \
    | tar xzf - --strip-components=3 -C /usr/local/bin/; \
  echo "4cf67f972aad3425bccc48af83f8cb59ddcc96de49d3bb21cdbbcbbeee31718ef681e551d13343538a6e70c2a4ea0435e4540bc1f8cf1a91a2f73265f52b9429 $F" \
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
