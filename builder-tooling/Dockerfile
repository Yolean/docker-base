FROM golang:1.16.7-buster@sha256:8e8910fa802194a30d5ebfbf3065d304e9e853ac50466c523be07ca657d9d6a1 as golang

FROM yolean/builder-base

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
