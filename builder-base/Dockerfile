FROM --platform=$TARGETPLATFORM ghcr.io/yolean/ystack-runner:4780bd518d0a29f4f110fd4c68caefedba669578@sha256:0f0a0333352ee1c4f6b9bbc76cb4016d233a03a6b74c6bd7edae5f6658d2615b \
  as base

FROM base as nonroot
USER root
WORKDIR /nonroot

RUN set -e; \
  mkdir workspace && chgrp nogroup workspace && chmod g+w workspace; \
  mkdir -p usr/local/src/ystack/bin && chown nonroot usr/local/src/ystack/bin; \
  mkdir -p home/nonroot/.cache/ystack-bin; \
  mkdir -p home/nonroot/.cache/npm; \
  (cd usr/local/src/ystack/bin/; ln -s /usr/local/lib/node_modules/yarn/bin/yarn); \
  chown root home; chown -R nonroot:nogroup home/nonroot

FROM base
COPY --from=nonroot /nonroot /
WORKDIR /workspace

ENV \
  CI=true \
  YSTACK_BIN_DOWNLOAD_CACHE=/home/nonroot/.cache/ystack-bin \
  npm_config_update_notifier=false

RUN npm install -g --ignore-scripts --no-bin-links yarn@1.22.19
