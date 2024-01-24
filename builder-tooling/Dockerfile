FROM --platform=$TARGETPLATFORM golang:1.21-bookworm@sha256:d8c365d63879c2312e332cb796961f2695dd65124ceb3c0247d9c5426b7dde5f as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
