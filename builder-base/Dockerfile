FROM --platform=$TARGETPLATFORM ghcr.io/yolean/ystack-runner:a2d55d29f4ff9ba3b2fc7995de3d80eef71a81b7@sha256:2388a53b1e973951dab268b9f3ec5238fb99199c0c850e32e30a8e0f89abb95e \
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
RUN npm install -g --ignore-scripts pnpm@11.13.0
USER nonroot:nogroup

