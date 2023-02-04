FROM --platform=$TARGETPLATFORM golang:1.19-bullseye@sha256:07798e0b7c37e6f7afe624a7841fee6b5f557e9c2d50b52a942a7b5ad2db35db as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
