FROM --platform=$TARGETPLATFORM golang:1.26.1-trixie@sha256:ab8c4944b04c6f97c2b5bffce471b7f3d55f2228badc55eae6cce87596d5710b as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
