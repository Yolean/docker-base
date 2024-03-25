FROM --platform=$TARGETPLATFORM golang:1.21-bookworm@sha256:05a9064db595ba2a6aa7c2d48d16ba5872c42583606741c750b0d895e9d0a09d as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
