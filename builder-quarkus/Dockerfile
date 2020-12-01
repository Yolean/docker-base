FROM maven:3.6.3-adoptopenjdk-11@sha256:a77fd5bdeebda213749e5050ae68f53aa39dcfb7efb5ad507c70c9db6d0909b2 as maven

FROM yolean/builder-base

USER root

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='libsnappy1v5 liblz4-1 libzstd1'; \
  buildDeps='build-essential zlib1g-dev libsnappy-dev liblz4-dev libzstd-dev'; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  # Keeping build deps for native compile
  #apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

ARG graalvm_version=20.3.0
ARG graalvm_variant=java11
ARG graalvm_releases=graalvm/graalvm-ce-builds
ARG graalvm_build=
ENV graalvm_dist=https://github.com/${graalvm_releases}/releases/download/vm-${graalvm_version}${graalvm_build}/graalvm-ce-${graalvm_variant}-linux-amd64-${graalvm_version}.tar.gz

RUN set -ex; \
  mkdir /opt/graalvm; \
  curl -sLS $graalvm_dist | \
    tar xzf - --strip-components=1 -C /opt/graalvm; \
  rm /opt/graalvm/lib/src.zip; \
  rm -r /opt/graalvm/lib/polyglot; \
  rm -r /opt/graalvm/lib/visualvm; \
  rm -r /opt/graalvm/tools

RUN [ "$PATH" = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin" ]
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/opt/graalvm/bin

RUN gu install native-image

ENV CI=true

COPY --from=maven /usr/share/maven /usr/share/maven
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME=/usr/share/maven
ENV MAVEN_CONFIG=/home/nonroot/.m2

RUN set -e; \
  mkdir -p /home/nonroot/.m2/builder-repository && ln -s /home/nonroot/.m2/builder-repository /home/nonroot/.m2/repository && chown -R nonroot:nogroup /home/nonroot/.m2; \
  mkdir -p /root/.m2 && chmod 500 /root/.m2; \
  mkdir -p /tekton/home/.m2 && chmod 500 /tekton/home/.m2; \
  ln -sv /usr/local/src/ystack/bin/deno /deno # for runtime-quarkus-dev to match runtime-quarkus-deno

USER nonroot:nogroup

ARG quarkus_version=1.10.1.Final
ARG quarkus_extensions=smallrye-openapi,swagger-ui,logging-json,resteasy-jackson,hibernate-validator,vertx,smallrye-health,smallrye-metrics,smallrye-fault-tolerance,smallrye-reactive-messaging-kafka,kubernetes-client

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

ARG additional_dependencies=" \
  com.networknt:json-schema-validator:1.0.45 \
  org.jsonschema2pojo:jsonschema2pojo-maven-plugin:1.0.2:jar \
  io.radanalytics:abstract-operator-annotator:0.6.7:jar \
  io.cloudevents:cloudevents-kafka:2.0.0.RC1:jar \
  com.salesforce.kafka.test:kafka-junit-core:3.2.2:jar \
"
RUN set -e; \
  for A in ${additional_dependencies}; do mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.2:get -Dartifact=$A; done

COPY --chown=nonroot:nogroup y-build-* /usr/local/bin/
