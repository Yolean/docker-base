FROM --platform=$BUILDPLATFORM yolean/builder-base
ARG TARGETARCH
ARG DUCKDB_TAG=v1.2.1

RUN set -ex; \
  ARCH=$TARGETARCH; \
  [ "$TARGETARCH" != "arm64" ] || ARCH=aarch64; \
  DUCKDB_RELEASE=https://github.com/duckdb/duckdb/releases/download/${DUCKDB_TAG}/duckdb_cli-linux-${ARCH}.gz; \
  curl -I $DUCKDB_RELEASE; \
  curl -L $DUCKDB_RELEASE | gunzip > /tmp/duckdb; \
  chmod u+x /tmp/duckdb; \
  sha256sum /tmp/duckdb

# https://github.com/duckdb/duckdb-ui/discussions/84
RUN echo '#!/bin/sh' > /tmp/xdg-open && chmod u+x /tmp/xdg-open

# TODO needs a bit more distro than gcr.io/distroless/base but not this much
FROM --platform=$TARGETPLATFORM yolean/homedir

# TODO note
# Failed to download extension "ui" at URL "http://extensions.duckdb.org/v1.2.1/linux_arm64_gcc4/ui.duckdb_extension.gz" (HTTP 403)
# Extension "ui" is an existing extension.

COPY --from=0 /tmp/duckdb /tmp/xdg-open /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/duckdb"]
