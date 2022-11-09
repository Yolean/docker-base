FROM --platform=$TARGETPLATFORM golang:1.19-bullseye@sha256:34e901ebac66df44ce97b56a9e1bb407307e54fe13e843d6c59da7826ce4dd2c as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
