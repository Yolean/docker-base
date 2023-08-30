FROM --platform=$TARGETPLATFORM golang:1.21-bookworm@sha256:640f192f24852cd875514e18a01977ae87692dca466abed7705ad3c4670b6993 as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
