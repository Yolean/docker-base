FROM --platform=$TARGETPLATFORM ghcr.io/yolean/ystack-runner:342face8d51c71072701061aa1086b8cbfefa51c@sha256:48c2783e0211b5a4fea45e1724a37854cf6a7c8c6ab590ba5662d0453afe8a67 \
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
