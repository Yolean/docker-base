FROM registry.access.redhat.com/ubi8/ubi-minimal:8.1@sha256:9285da611437622492f9ef4229877efe302589f1401bbd4052e9bb261b3d4387

WORKDIR /workspace

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'
# To install bash-completion we probably need: -y --enablerepo=rhel-8-for-x86_64-baseos-rpms
RUN microdnf install openssl ca-certificates curl procps lz4 bash tar gzip bind-utils iputils shadow-utils \
    && microdnf update \
    && microdnf clean all

COPY --from=solsson/kafka-cli@sha256:9fa3306e9f5d18283d10e01f7c115d8321eedc682f262aff784bd0126e1f2221 /usr/local/bin/* /usr/local/bin/
COPY --from=solsson/kafka-cli@sha256:9fa3306e9f5d18283d10e01f7c115d8321eedc682f262aff784bd0126e1f2221 bin bin

#COPY --from=edenhill/kafkacat:1.5.0@sha256:05daf8af237495df2bc726427e421d101072cf2d2306fb2379243acbffe40823 /usr/bin/kafkacat /usr/local/bin/
COPY --from=confluentinc/cp-kafkacat:5.4.0-1-ubi8@sha256:5515cf85f50b1ac260b1067e9cd3ce46f0a9ba9167338d563742605c85b8bea5 /usr/local/bin/kafkacat /usr/local/bin/
COPY --from=confluentinc/cp-kafkacat:5.4.0-1-ubi8@sha256:5515cf85f50b1ac260b1067e9cd3ce46f0a9ba9167338d563742605c85b8bea5 /usr/lib64/libzstd.so.1* /usr/lib64/

COPY --from=minio/mc:RELEASE.2020-02-25T18-10-03Z@sha256:d122cc5152218b16c79d4950a20910bd2c714ca661544271c5eaff4dfd51bc57 /usr/bin/mc /usr/local/bin/

RUN set -e; \
  curl -sLS -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64; \
  chmod a+x /usr/local/bin/jq

RUN set -e; \
  curl -sLS -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/3.1.2/yq_linux_amd64; \
  chmod a+x /usr/local/bin/yq

RUN set -e; \
  F=$(mktemp); \
  curl -SLs https://dl.k8s.io/v1.15.10/kubernetes-client-linux-amd64.tar.gz \
    | tee $F \
    | tar xzf - --strip-components=3 -C /usr/local/bin/; \
  echo "02037072280ca4697acc6ea9f75e8f21050b740268861cbd9d2aa0b811d7812527140ec48d6eda48bc2b42ac3bd13612efe44456bf7b178848b968b41addf7ab $F" \
    | sha512sum -c -; \
  rm $F

#RUN groupadd -g 65532 nonroot && \
#  useradd --create-home --home-dir /home/nonroot --uid 65532 --gid 65532 -c nonroot -s /usr/sbin/nologin nonroot
#USER nonroot:nonroot
RUN set -e; \
  groupadd -g 65532 nonroot; \
  adduser --uid 65532 --gid 65532 -s /sbin/nologin nonroot; \
  chown nonroot /workspace
USER nonroot:nonroot

RUN set -ex; \
  kafka-topics 2>&1 | head -n 1; \
  kafka-configs 2>&1 | head -n 1; \
  kafka-consumer-groups 2>&1 | head -n 1; \
  openssl version; \
  curl --version; \
  mc --version; \
  jq --version; \
  yq --version; \
  kafkacat -V
