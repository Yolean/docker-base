FROM --platform=$TARGETPLATFORM maven:3.9.11-eclipse-temurin-25@sha256:3d35095b456f61758a4b3f62c746bffd369d5cabaf6c04ea4387a96dc6640972 as maven

FROM docker:28.5.1-cli@sha256:55e613fd4f85d921ce1ba31a1fbdab404fbf992c7ec7750940ad965102ece800 AS dockerclient

FROM --platform=$TARGETPLATFORM yolean/builder-base as mandrel
ARG TARGETARCH
ARG MANDREL_JAVA_VERSION=java25
ARG MANDREL_VERSION=25.0.0.1-Final

RUN set -ex; \
  ARCH=$TARGETARCH; \
  [ "$TARGETARCH" != "arm64" ] || ARCH=aarch64; \
  MANDREL_DIST=mandrel-$MANDREL_JAVA_VERSION-linux-$ARCH-$MANDREL_VERSION.tar.gz; \
  MANDREL_DIST_URL=https://github.com/graalvm/mandrel/releases/download/mandrel-$MANDREL_VERSION/$MANDREL_DIST; \
  MANDREL_DIST_SHA256=$(curl -sLSf "$MANDREL_DIST_URL.sha256"); \
  [ -n "$MANDREL_DIST_SHA256" ]; \
  cd /home/nonroot; \
  curl -o $MANDREL_DIST -sLSf $MANDREL_DIST_URL; \
  echo "$MANDREL_DIST_SHA256" | sha256sum -c -; \
  mkdir ./mandrel; \
  tar xzf $MANDREL_DIST --strip-components=1 -C ./mandrel

RUN rm -v /home/nonroot/mandrel/lib/src.zip

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=maven /usr/share/maven /usr/share/maven
COPY --from=mandrel /home/nonroot/mandrel /opt/mandrel
COPY --from=dockerclient /usr/local/bin/* /usr/local/bin/
COPY --from=dockerclient /usr/local/libexec/docker /usr/local/libexec/docker
COPY --chown=nonroot:nogroup y-build-* /usr/local/bin/

ENV \
  CI=true \
  GRAALVM_HOME=/opt/mandrel \
  JAVA_HOME=/opt/mandrel \
  MAVEN_HOME=/usr/share/maven \
  MAVEN_CONFIG=/home/nonroot/.m2 \
  PATH="${PATH}:/usr/share/maven/bin:/opt/mandrel/bin"
