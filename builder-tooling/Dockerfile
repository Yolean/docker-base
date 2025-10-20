FROM --platform=$TARGETPLATFORM golang:1.25.3-trixie@sha256:ec34da704131e660a918be22604901ede84cf969070c97128ab0f0ed9c7939dd as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
