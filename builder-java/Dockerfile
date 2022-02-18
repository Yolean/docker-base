FROM --platform=$TARGETPLATFORM yolean/builder-base
ARG TARGETARCH

RUN echo "TARGETARCH $TARGETARCH" && false

USER root

RUN runtimeDeps='default-jdk-headless maven unzip' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

RUN set -e; \
  mkdir /opt/protoc; \
  cd /opt/protoc; \
  curl -sL -o protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/v3.12.3/protoc-3.12.3-linux-x86_64.zip; \
  unzip protoc.zip; \
  ln -s /opt/protobuf/bin/protoc /usr/local/bin/protoc

ENV GRADLE_VERSION=6.5.1

RUN set -e; \
  cd /opt; \
  curl -sL -o gradle.zip https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-all.zip; \
  unzip gradle.zip; \
  ln -s /opt/gradle-$GRADLE_VERSION/bin/gradle /usr/local/bin/gradle

USER nonroot:nogroup
