# Note the hardcoded JAVA_VERSION string below, and in runtime-quarkus-ubuntu-jre
FROM --platform=$TARGETPLATFORM eclipse-temurin:11.0.14.1_1-jdk-focal@sha256:e1b5c25bb18d8651d17ebde11127ee72b4b45ce84d7ed09d14deb0167b3393ea as jdk

RUN echo "JAVA_VERSION=$JAVA_VERSION"

FROM --platform=$TARGETPLATFORM yolean/runtime-quarkus-ubuntu

# Version here must match that of JRE above
# Path must be that of runtime-quarkus + $JAVA_HOME/bin
ENV JAVA_VERSION=jdk-11.0.14.1+1 \
  JAVA_HOME=/opt/java/openjdk \
  PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY --from=jdk /opt/java/openjdk /opt/java/openjdk

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
