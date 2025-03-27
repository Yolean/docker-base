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

# TODO needs a bit more distro than gcr.io/distroless/base but not this much
FROM --platform=$TARGETPLATFORM yolean/docker-base

COPY --from=0 /tmp/duckdb /usr/local/bin/duckdb

ENTRYPOINT ["/usr/local/bin/duckdb"]
