FROM --platform=$TARGETPLATFORM docker.io/yolean/ystack-runner:336137b0115c5660172bb932a3735c6afe293774@sha256:774d35ed7fd86be4b8ac908ac7ea3a2ed037d5c0f8e9d7782e3dc25e85d555f8 \
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
