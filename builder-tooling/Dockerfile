FROM --platform=$TARGETPLATFORM golang:1.21-bookworm@sha256:a44d05d5de3474f8135462903bbf74a0fdb761aec455ff557c467339dc0b729b as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
