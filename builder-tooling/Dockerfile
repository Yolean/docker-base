FROM golang:1.16.8-buster@sha256:8f8827dd0aaca2d1e1bba0b69c5cb15a7560b6a53ae540fd90be6c0e4fdc4db4 as golang

FROM yolean/builder-base

RUN apt-get install -y --no-install-recommends build-essential

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
