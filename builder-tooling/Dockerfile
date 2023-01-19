FROM --platform=$TARGETPLATFORM golang:1.19-bullseye@sha256:c3feb4bc19853836e788b21051b76b813a30457b3f77058991d3e170af0afa65 as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
