FROM --platform=$TARGETPLATFORM maven:3.9.9-eclipse-temurin-21@sha256:9ae8f001f2d978fdfe36052cc9950eda99929d410e2b1f03bd35c09f49890fc9 as maven

FROM docker:28.0.1-cli@sha256:18018c4b6e75bab6b93e04159c83778c98b60b0f95c762967bb501d684553daf AS dockerclient

FROM --platform=$TARGETPLATFORM yolean/builder-base as mandrel
ARG TARGETARCH
ARG JAVA_VERSION=java21
ARG MANDREL_VERSION=23.1.6.0-Final

RUN set -ex; \
  ARCH=$TARGETARCH; \
  [ "$TARGETARCH" != "arm64" ] || ARCH=aarch64; \
  MANDREL_DIST=mandrel-$JAVA_VERSION-linux-$ARCH-$MANDREL_VERSION.tar.gz; \
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
