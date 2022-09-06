FROM --platform=$TARGETPLATFORM golang:1.19-bullseye@sha256:00e31be58387c043548c4ec6d7cb7719c25bfa06563de567fb03c2c957dabed0 as golang

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/src/ystack/bin:/usr/local/go/bin \
  GOPATH=/home/nonroot/.cache/go
