ARG TAG_CURL=8.9.1

FROM --platform=$TARGETPLATFORM yolean/builder-base as ystack-runner

FROM --platform=$TARGETPLATFORM ghcr.io/yolean/curl:${TAG_CURL}

COPY --from=ystack-runner /usr/local/src/ystack/bin/y-yq-v* /usr/bin/yq

# bypass entrypoint.sh
ENTRYPOINT ["/usr/bin/curl"]

# so we get root/nonroot build
USER root
