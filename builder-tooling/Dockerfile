FROM --platform=$TARGETPLATFORM golang:1.25.5-trixie@sha256:ef151f0384896831258e71065176f1e63f5a90bcbe6a98ec679a1990011a2655 as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
