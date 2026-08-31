FROM --platform=$TARGETPLATFORM ghcr.io/yolean/ystack-runner:4e5fd753897c1de9caab471e314979fab95d24ce@sha256:68d18aea67336dc6e39a332524a59164b20dc1dd9d12fbd39a46ac03f8c27988 \
  as base

FROM base as nonroot
USER root
WORKDIR /nonroot

RUN set -e; \
  mkdir workspace && chgrp nogroup workspace && chmod g+w workspace; \
  mkdir -p usr/local/src/ystack/bin && chown nonroot usr/local/src/ystack/bin; \
  mkdir -p home/nonroot/.cache/ystack-bin; \
  mkdir -p home/nonroot/.cache/npm; \
  chown root home; chown -R nonroot:nogroup home/nonroot

FROM base
COPY --from=nonroot /nonroot /
WORKDIR /workspace

ENV \
  CI=true \
  YSTACK_BIN_DOWNLOAD_CACHE=/home/nonroot/.cache/ystack-bin \
  npm_config_update_notifier=false

USER root
RUN npm install -g --ignore-scripts pnpm@11.24.0
USER nonroot:nogroup

