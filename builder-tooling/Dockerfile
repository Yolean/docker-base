FROM --platform=$TARGETPLATFORM golang:1.19-bullseye@sha256:399a26403fd88e2f64a85891f59953b5a6ade5319c4435ac46dfcb133ada5cf3 as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
