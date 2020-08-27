FROM yolean/builder-base as builder-base

FROM maven:3.6.3-adoptopenjdk-11@sha256:a32adccbff3a0ad0a6072b76c45cad5cb2e8ed6145660aadaf9ec9a9fd9ffb7a as maven

FROM oracle/graalvm-ce:20.2.0-java11@sha256:e81677e781fa233b49ebb511acc4a43759b9bb66bd19da3ba38b3888fd9185a2

RUN gu install native-image

ENV CI=true

COPY --from=builder-base /usr/local/src/ystack/bin/crane /usr/local/bin/crane

COPY --from=maven /usr/share/maven /usr/share/maven
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME=/usr/share/maven
ENV MAVEN_CONFIG=/home/nonroot/.m2

RUN set -e; \
  mkdir -p /root/.m2 && chmod 500 /root/.m2; \
  mkdir -p /tekton/home/.m2 && chmod 500 /tekton/home/.m2

# # https://github.com/Yolean/ystack/commit/46696ab3300050c6fbad22540a6f0d113717681b#diff-9a949ad7c7f021d1ee63246d4c9011d6R11
# COPY --from=builder-base /usr/local/lib/node_modules/@yolean/ystack /opt/graalvm/languages/js/lib/node_modules/@yolean/ystack
# RUN for B in \
#   tsc ts-node \
#   jest ts-jest \
#   rollup \
#   ; do ln -s -v /opt/graalvm/languages/js/lib/node_modules/@yolean/ystack/node_modules/.bin/$B /opt/graalvm/bin/$B; done

# Like ubuntu
RUN echo 'nogroup:x:65534:' | tee -a /etc/group

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

# Same as github.com/solsson/dockerfiles/tree/master/kafka-nonroot, and ystack's runner.Dockerfile
RUN echo 'nonroot:x:65532:65534:nonroot:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot
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
