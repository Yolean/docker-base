FROM golang:1.17.2-buster@sha256:354b787d74581e072430f4d49e2dd0ab30bcca0c8f85a3b74a8027e1bef58007 as golang

FROM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
