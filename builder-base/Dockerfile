FROM --platform=$TARGETPLATFORM docker.io/yolean/ystack-runner:6aa2e2badb3ac3ce29adcaa28a67532bcba49e48@sha256:4ac4a43e79538baa7913a1e9b0d61b47f57b392be3dfa0913dc37d236897c5ea \
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
