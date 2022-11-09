FROM maven:3.8.6-eclipse-temurin-17-focal@sha256:3ffb55e4a6e29756f332abf1503ce0b295662f7233611123f496efcf77ec420c as maven

FROM yolean/builder-base

USER root

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='libsnappy1v5 libsnappy-jni liblz4-1 liblz4-jni libzstd1'; \
  buildDeps='build-essential zlib1g-dev libsnappy-dev liblz4-dev libzstd-dev'; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  # Keeping build deps for native compile
  #apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

ARG graalvm_version=22.3.0.1
ARG graalvm_variant=java17
ARG graalvm_releases=graalvm/graalvm-ce-builds
ARG graalvm_build=
ENV graalvm_dist=https://github.com/${graalvm_releases}/releases/download/vm-${graalvm_version}${graalvm_build}/graalvm-ce-${graalvm_variant}-linux-amd64-${graalvm_version}.tar.gz

RUN set -ex; \
  mkdir /opt/graalvm; \
  curl -sLS $graalvm_dist | \
    tar xzf - --strip-components=1 -C /opt/graalvm; \
  rm /opt/graalvm/lib/src.zip; \
  rm -r /opt/graalvm/lib/visualvm

RUN [ "$PATH" = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin" ]
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/opt/graalvm/bin

RUN gu install native-image

ENV CI=true

COPY --from=maven /usr/share/maven /usr/share/maven
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME=/usr/share/maven
ENV MAVEN_CONFIG=/home/nonroot/.m2

USER nonroot:nogroup
