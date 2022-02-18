FROM maven:3.8.4-eclipse-temurin-11@sha256:ac478e512f8665c3fd5f853ea89e68a455a826996b4ed00712dfc9810a2b1f2d as maven

FROM quay.io/quarkus/ubi-quarkus-mandrel:22.0.0.2-Final-java11@sha256:b0a6375752732eb679dcf5e491537dca7d9403471d7593610d571116bf805a19 as mandrel

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
