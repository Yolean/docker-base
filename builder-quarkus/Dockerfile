FROM yolean/builder-base as builder-base

FROM solsson/kafka:graalvm@sha256:4f4abbf331d3e4b86a0e94a166bc796563f3792ab357eccbd039bf0c969d2d2f

ENV CI=true

# https://github.com/Yolean/ystack/commit/46696ab3300050c6fbad22540a6f0d113717681b#diff-9a949ad7c7f021d1ee63246d4c9011d6R11
COPY --from=builder-base /usr/local/lib/node_modules/@yolean/ystack /opt/graalvm/languages/js/lib/node_modules/@yolean/ystack
RUN for B in \
  tsc ts-node \
  jest ts-jest \
  rollup \
  ; do ln -s -v /opt/graalvm/languages/js/lib/node_modules/@yolean/ystack/node_modules/.bin/$B /opt/graalvm/bin/$B; done

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

# Same as github.com/solsson/dockerfiles/tree/master/kafka-nonroot, and ystack's runner.Dockerfile
RUN echo 'nonroot:x:65532:65534:nonroot:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot
USER nonroot:nogroup

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
