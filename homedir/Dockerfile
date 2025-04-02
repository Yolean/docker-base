FROM --platform=$TARGETPLATFORM yolean/docker-base \
  as base

FROM base as nonroot
WORKDIR /nonroot
RUN set -e; \
  mkdir -p home/nonroot/.cache; \
  chown root home; chown -R 65532:65534 home/nonroot

FROM base
COPY --from=nonroot /nonroot /
