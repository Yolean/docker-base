FROM yolean/builder-quarkus

ARG quarkus_version=2.7.1.Final
ARG quarkus_extensions=smallrye-openapi,swagger-ui,logging-json,resteasy-jackson,hibernate-validator,vertx,smallrye-health,micrometer,smallrye-fault-tolerance,smallrye-reactive-messaging-kafka,kubernetes-client

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
  com.networknt:json-schema-validator:1.0.66 \
  org.jsonschema2pojo:jsonschema2pojo-maven-plugin:1.1.1:jar \
  io.radanalytics:abstract-operator-annotator:0.6.7:jar \
  io.cloudevents:cloudevents-kafka:2.3.0:jar \
"
RUN set -e; \
  for A in ${additional_dependencies}; do mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.2:get -Dartifact=$A; done
