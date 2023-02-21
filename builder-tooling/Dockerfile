FROM --platform=$TARGETPLATFORM golang:1.20-bullseye@sha256:c3fbdc381fb6b78325c2a5cc1bf0c288c0d173568fba3f1b8894a51837cccf7f as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
