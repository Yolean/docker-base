FROM --platform=$TARGETPLATFORM golang:1.23-bookworm@sha256:558c9ecc3418f90a89919a9ce440a42eb130314c92401a9de19f5566a6eb275e as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
