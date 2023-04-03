FROM --platform=$TARGETPLATFORM golang:1.20-bullseye@sha256:cb95e56313475447c4f1ba5262ddd7c6ba2c66cdb62c0c699001e8fa1755480f as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
