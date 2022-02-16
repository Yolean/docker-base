FROM --platform=$TARGETPLATFORM golang:1.17.7-bullseye@sha256:f89b6b9ec155b8c5e04d18fc23f6cb915e17ad8fe3f1cf7e9c7b7122a6c509a9 as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
