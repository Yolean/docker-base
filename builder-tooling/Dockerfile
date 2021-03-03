FROM golang:1.15.8-buster@sha256:21e7c2b2de6e7b600b945f816ee463dea69784a2bf18bfe21f758b1278dba80e as golang

FROM yolean/builder-base

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin
