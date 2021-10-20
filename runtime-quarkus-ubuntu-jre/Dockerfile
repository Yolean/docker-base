FROM java as jre

RUN echo "JAVA_VERSION=$JAVA_VERSION"

FROM runtime-quarkus-ubuntu

# Version here must match that of JRE above
# Path must be that of runtime-quarkus + $JAVA_HOME/bin
ENV JAVA_VERSION=jdk-11.0.12+7 \
  JAVA_HOME=/opt/java/openjdk \
  PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY --from=jre /opt/java/openjdk /opt/java/openjdk

# with: COPY --from=dev /workspace/target/quarkus-app /app
WORKDIR /app
ENTRYPOINT [ "java", \
  "-Dquarkus.http.host=0.0.0.0", \
  "-Djava.util.logging.manager=org.jboss.logmanager.LogManager", \
  "-jar", "quarkus-run.jar" ]
