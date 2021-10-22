FROM maven:3.8.1-adoptopenjdk-11@sha256:34bd76497d79aeda09b3c69db6af1633e3c155b45dae771f0855824b4dfc2948 as maven

FROM quay.io/quarkus/ubi-quarkus-mandrel:21.3.0.0-Final-java11@sha256:313fabf8a25d3deb192baa35436ee20936c3aeb59ff4217a73ee50de95f2dbf1 as mandrel

FROM yolean/builder-base-gcc

COPY --from=maven /usr/share/maven /usr/share/maven
COPY --from=mandrel /opt/mandrel /opt/mandrel

RUN [ "$PATH" = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin" ]
ENV \
  CI=true \
  GRAALVM_HOME=/opt/mandrel \
  JAVA_HOME=/opt/mandrel \
  MAVEN_HOME=/usr/share/maven \
  MAVEN_CONFIG=/home/nonroot/.m2 \
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/share/maven/bin:/opt/mandrel/bin
