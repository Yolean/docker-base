FROM --platform=$TARGETPLATFORM ghcr.io/yolean/ystack-runner:e4adb879fa5bc8758f006cfd07160ea09d455f21@sha256:eeee27b57f5b461b013537226770b665cca4d78af7b65b48212a0fa552359ae1 \
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
RUN npm install -g --ignore-scripts pnpm@11.17.0
USER nonroot:nogroup

