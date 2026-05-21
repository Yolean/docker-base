FROM --platform=$BUILDPLATFORM yolean/builder-base
ARG TARGETARCH
ARG DUCKDB_TAG=v1.5.3

# Prebuilt, official DuckDB CLI plus the prebuilt, signed extensions we bundle for
# offline use. Nothing is compiled here, so the build is fast and cross-arch safe:
# the target-arch binary and extensions are only downloaded, never executed.
#   httpfs    — https:// and Google Cloud Storage gs:// access (also S3); core
#   nanoarrow — Apache Arrow IPC (the "arrow" alias); community
RUN set -ex; \
  ARCH=$TARGETARCH; \
  PLATFORM=linux_${ARCH}; \
  EXT_DIR=/tmp/.duckdb/extensions/${DUCKDB_TAG}/${PLATFORM}; \
  mkdir -p $EXT_DIR; \
  curl -fL https://github.com/duckdb/duckdb/releases/download/${DUCKDB_TAG}/duckdb_cli-linux-${ARCH}.gz \
    | gunzip > /tmp/duckdb; \
  chmod +x /tmp/duckdb; \
  sha256sum /tmp/duckdb; \
  curl -fL https://extensions.duckdb.org/${DUCKDB_TAG}/${PLATFORM}/httpfs.duckdb_extension.gz \
    | gunzip > $EXT_DIR/httpfs.duckdb_extension; \
  curl -fL https://community-extensions.duckdb.org/${DUCKDB_TAG}/${PLATFORM}/nanoarrow.duckdb_extension.gz \
    | gunzip > $EXT_DIR/nanoarrow.duckdb_extension; \
  ls -l $EXT_DIR

# https://github.com/duckdb/duckdb-ui/discussions/84
RUN echo '#!/bin/sh' > /tmp/xdg-open && chmod u+x /tmp/xdg-open

FROM --platform=$TARGETPLATFORM yolean/homedir

# duckdb resolves its extension directory from $HOME; set it explicitly so the bundled
# extensions are found whether the image runs as root or (via to-nonroot) as nonroot.
ENV HOME=/home/nonroot

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=0 /tmp/duckdb /tmp/xdg-open /usr/local/bin/
COPY --from=0 --chown=65532:65534 /tmp/.duckdb /home/nonroot/.duckdb

ENTRYPOINT ["/usr/local/bin/duckdb"]
