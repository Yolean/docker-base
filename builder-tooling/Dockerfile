FROM --platform=$TARGETPLATFORM golang:1.23-bookworm@sha256:6a3aa4fd2c3e15bc8cb450e4a0ae353fb73b5f593bcbb5b25ffeee860cc2ec2a as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
