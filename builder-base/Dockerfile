FROM docker.io/yolean/ystack-runner:72fbd593e11e6b9502350927dd95ce1751a18060@sha256:ccd19551c1c7ea9df0186187b5112e31febe7b5fbfce6fe618780ad3fe938e71 as base

FROM base as nonroot
USER root
WORKDIR /nonroot

RUN set -e; \
  mkdir workspace && chgrp nogroup workspace && chmod g+w workspace; \
  mkdir -p usr/local/src/ystack/bin && chown nonroot usr/local/src/ystack/bin; \
  mkdir -p home/nonroot/.cache/ystack-bin; \
  npm config set cache /home/nonroot/.cache/npm; \
  npm config list; \
  mkdir -p home/nonroot/.cache/npm; \
  mv $HOME/.npmrc home/nonroot/.npmrc; \
  chown root home; chown -R nonroot:nogroup home/nonroot

FROM base
COPY --from=nonroot /nonroot /
WORKDIR /workspace

ENV \
  CI=true \
  YSTACK_BIN_DOWNLOAD_CACHE=/home/nonroot/.cache/ystack-bin
