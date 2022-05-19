FROM --platform=$TARGETPLATFORM docker.io/yolean/ystack-runner:e4928b393e99c2eab06041290c9905448c5fad26@sha256:f5f24ce95489dc4d1514f413a4b3c1fa0f872e3180901653debf20f9f1a83ecc \
  as base

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
