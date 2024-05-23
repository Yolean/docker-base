FROM --platform=$TARGETPLATFORM golang:1.21-bookworm@sha256:9070cb6a424004bb46987bfee510666a362d6a332a6949b33b2b644a0e21d196 as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
