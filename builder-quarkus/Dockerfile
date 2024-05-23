FROM --platform=$TARGETPLATFORM maven:3.9.6-eclipse-temurin-21@sha256:a7fc7af5e97f7dc47f36a96fe1a08d7bccb9c5eebdb600522818087e960a3c71 as maven

FROM --platform=$TARGETPLATFORM yolean/builder-base as mandrel
ARG TARGETARCH
ARG JAVA_VERSION=java21
ARG MANDREL_VERSION=23.1.3.1-Final

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
COPY --chown=nonroot:nogroup y-build-* /usr/local/bin/

RUN [ "$PATH" = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin" ]
ENV \
  CI=true \
  GRAALVM_HOME=/opt/mandrel \
  JAVA_HOME=/opt/mandrel \
  MAVEN_HOME=/usr/share/maven \
  MAVEN_CONFIG=/home/nonroot/.m2 \
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/share/maven/bin:/opt/mandrel/bin
