FROM --platform=$BUILDPLATFORM yolean/builder-base
ARG TARGETARCH
ARG DUCKDB_TAG=v1.4.4

RUN set -ex; \
  ARCH=$TARGETARCH; \
  DUCKDB_RELEASE=https://github.com/duckdb/duckdb/releases/download/${DUCKDB_TAG}/duckdb_cli-linux-${ARCH}.gz; \
  curl -I $DUCKDB_RELEASE; \
  curl -L $DUCKDB_RELEASE | gunzip > /tmp/duckdb; \
  chmod u+x /tmp/duckdb; \
  sha256sum /tmp/duckdb

# https://github.com/duckdb/duckdb-ui/discussions/84
RUN echo '#!/bin/sh' > /tmp/xdg-open && chmod u+x /tmp/xdg-open

FROM --platform=$TARGETPLATFORM yolean/homedir

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=0 /tmp/duckdb /tmp/xdg-open /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/duckdb"]
