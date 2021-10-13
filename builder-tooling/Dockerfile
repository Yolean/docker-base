FROM golang:1.17.2-bullseye@sha256:0ab91ed22604fea9e13ca4f03a545ec7ab48129b0030438dcf8c20f4f3e96fa5 as golang

FROM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
