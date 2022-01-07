FROM maven:3.8.4-eclipse-temurin-11@sha256:3aa27fd4c83c86357477daf9ac23dc67708b567c70047fa73f57fb919563ec6d as maven

FROM quay.io/quarkus/ubi-quarkus-mandrel:21.3-java11@sha256:43441b01da9a32a0bdc12bd9b033b99f4c26494fc54b214d34ef2c31ad18c122 as mandrel

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
