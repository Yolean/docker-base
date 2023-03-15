FROM --platform=$TARGETPLATFORM golang:1.20-bullseye@sha256:51ff22f03320894402290ba7dfd83ee05b61e58b5381d76b40f2e3a370d81da3 as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
