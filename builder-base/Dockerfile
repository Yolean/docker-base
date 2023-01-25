FROM --platform=$TARGETPLATFORM docker.io/yolean/ystack-runner:c51c50f7538030eea44f7061be2d0fee84b2d1ca@sha256:a6a30d7ce293f72681d491252ca5d4638ac7e9f99d47ad85f1ead36dab978a20 \
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
