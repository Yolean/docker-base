FROM maven:3.8.1-adoptopenjdk-11@sha256:34bd76497d79aeda09b3c69db6af1633e3c155b45dae771f0855824b4dfc2948 as maven

FROM quay.io/quarkus/ubi-quarkus-mandrel:21.2-java11@sha256:59b95021392d1d1487c05d62b7f25e442bf3813e5ef6d94ed5039a3211d7e0df as mandrel

FROM yolean/builder-base

USER root

# This image keeps buildDeps for runtime, used by native compile
RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='libsnappy1v5 libsnappy-jni liblz4-1 liblz4-jni libzstd1'; \
  buildDeps='build-essential zlib1g-dev libsnappy-dev liblz4-dev libzstd-dev'; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

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

USER nonroot:nogroup
