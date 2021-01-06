FROM golang:1.15.6-buster@sha256:f07de066d08e36e8c84da118bea13b448bc085364f6fc724c44744f6114c21a4 as golang

FROM yolean/builder-base

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin
