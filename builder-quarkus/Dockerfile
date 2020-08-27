FROM maven:3.6.3-adoptopenjdk-11@sha256:a32adccbff3a0ad0a6072b76c45cad5cb2e8ed6145660aadaf9ec9a9fd9ffb7a as maven

FROM yolean/builder-base as builder-base

ARG graalvm_version=20.2.0
ARG graalvm_variant=java11
ARG graalvm_releases=graalvm/graalvm-ce-builds
ARG graalvm_build=

USER root

RUN set -ex; \
  cd /opt; \
  curl -sLS -o graalvm.tar.gz https://github.com/${graalvm_releases}/releases/download/vm-${graalvm_version}${graalvm_build}/graalvm-ce-${graalvm_variant}-linux-amd64-${graalvm_version}.tar.gz; \
  tar xvzf graalvm.tar.gz; \
  mv graalvm-ce-${graalvm_variant}-${graalvm_version} graalvm; \
  rm graalvm.tar.gz

RUN [ "$PATH" = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin" ]
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/opt/graalvm/bin

RUN gu install native-image

ENV CI=true

COPY --from=maven /usr/share/maven /usr/share/maven
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME=/usr/share/maven
ENV MAVEN_CONFIG=/home/nonroot/.m2

RUN set -e; \
  mkdir -p /root/.m2 && chmod 500 /root/.m2; \
  mkdir -p /tekton/home/.m2 && chmod 500 /tekton/home/.m2

USER nonroot:nogroup

ARG quarkus_version=1.7.1.Final
ARG quarkus_extensions=logging-json,resteasy-jackson,hibernate-validator,vertx,smallrye-health,smallrye-metrics,smallrye-fault-tolerance,smallrye-reactive-messaging-kafka

RUN set -e; \
  mvn --batch-mode io.quarkus:quarkus-maven-plugin:${quarkus_version}:create \
    -DprojectGroupId=se.yolean \
    -DprojectArtifactId=builder-cache \
    -DclassName="org.acme.validation.TempResource" \
    -Dpath="/downloading-dependencies" \
    -Dextensions="${quarkus_extensions}"; \
  cd builder-cache; \
  mvn --batch-mode package; \
  mvn --batch-mode package -Pnative -Dquarkus.native.additional-build-args=--dry-run -Dmaven.test.skip=true 1>/dev/null || true; \
  cd ..; \
  rm -r builder-cache

COPY --chown=nonroot:nogroup y-build-* /usr/local/bin/
