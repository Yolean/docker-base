FROM --platform=$TARGETPLATFORM docker.io/yolean/ystack-runner:eb59760ecb12d26f6b7692f09a828c9eca78fbce@sha256:14ee714c2d47859dbe4922b90e2c66e7fdadf1ce915c11bdb53a1b02bf4308ad as base

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
