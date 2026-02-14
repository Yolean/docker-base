FROM --platform=$TARGETPLATFORM maven:3.9.12-eclipse-temurin-25@sha256:b8187abd63cd4ee8c596aae910ce698a10db6d27ad5be08d574f3b928526724e as maven

FROM docker:29.2.1-cli@sha256:1d6d751f1d68d1a5142c23c730ef5ecc976a8e050fa08c3cdb09f7e2e54a4439 AS dockerclient

FROM --platform=$TARGETPLATFORM yolean/builder-base as mandrel
ARG TARGETARCH
ARG MANDREL_JAVA_VERSION=java25
ARG MANDREL_VERSION=25.0.2.0-Final

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
