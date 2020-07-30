FROM solsson/kafka:graalvm-nonroot@sha256:28505c768b7f8b44168b9df5bc27dc4735d1be75ea5a12eb94c34af2d661e66a

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

# Same as github.com/solsson/dockerfiles/tree/master/kafka-nonroot, and ystack's runner.Dockerfile
RUN echo 'nonroot:x:65532:65534:nonroot:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot
USER nonroot:nogroup

COPY y-build-* /usr/local/bin/

ARG quarkus_version=1.6.1.Final
ARG quarkus_extensions=resteasy-jackson,kafka,hibernate-validator,vertx

RUN set -e; \
  mvn --batch-mode io.quarkus:quarkus-maven-plugin:1.6.1.Final:create \
    -DprojectGroupId=se.yolean \
    -DprojectArtifactId=builder-cache \
    -DclassName="org.acme.validation.TempResource" \
    -Dpath="/downloading-dependencies" \
    -Dextensions="resteasy-jsonb, hibernate-validator"; \
  cd builder-cache; \
  mvn --batch-mode package; \
  mvn --batch-mode package -Pnative -Dquarkus.native.additional-build-args=--dry-run -Dmaven.test.skip=true 1>/dev/null || true; \
  cd ..; \
  rm -r builder-cache
