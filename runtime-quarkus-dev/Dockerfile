FROM --platform=$TARGETPLATFORM yolean/builder-quarkus as maven

RUN mkdir -p /home/nonroot/.m2

# Note the hardcoded JAVA_VERSION string below, and in runtime-quarkus-ubuntu-jre
FROM --platform=$TARGETPLATFORM eclipse-temurin:17.0.4.1_1-jdk-focal@sha256:2ccbdff7afb47c55b675bedee8a287962ca2e0044cd9b94b115b8ee99371d1c0 as jdk

RUN echo "JAVA_VERSION=$JAVA_VERSION"

FROM --platform=$TARGETPLATFORM yolean/runtime-quarkus-ubuntu:root

# Version here must match that of JRE above
# Path must be that of runtime-quarkus + $JAVA_HOME/bin
ENV JAVA_VERSION=jdk-17.0.4.1+1 \
  JAVA_HOME=/opt/java/openjdk \
  MAVEN_HOME=/usr/share/maven \
  MAVEN_CONFIG=/home/nonroot/.m2 \
  PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/share/maven/bin

COPY --from=jdk /opt/java/openjdk /opt/java/openjdk
COPY --from=maven /usr/share/maven /usr/share/maven
COPY --from=maven --chown=nonroot:nogroup /home/nonroot/.m2 /home/nonroot/.m2

WORKDIR /workspace

EXPOSE 8080
ENTRYPOINT [ \
  "mvn", \
  "compile", \
  "quarkus:dev" ]
CMD [ \
  "-Djava.util.logging.manager=org.jboss.logmanager.LogManager", \
  "-Dquarkus.http.host=0.0.0.0", \
  "-Dquarkus.http.port=8080" ]
