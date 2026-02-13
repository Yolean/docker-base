FROM --platform=$TARGETPLATFORM ghcr.io/yolean/ystack-runner:517b53cd202a78ed01d25a33b870677e55d36def@sha256:b8f660292f187c8aa9881ef52f122367ba5149dabaa253199202ca27931a9204 \
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
