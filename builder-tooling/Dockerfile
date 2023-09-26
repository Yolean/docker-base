FROM --platform=$TARGETPLATFORM golang:1.21-bookworm@sha256:9c7ea4a4924ae24913401af45c9b6f439d0f782267584738d1cc1099d8b7a02c as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
