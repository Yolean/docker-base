FROM docker.io/yolean/ystack-runner:8be0a608b71419d23197da9d94f74c158d574ec4@sha256:254edfec3a691d3dc2ca5f8a161733689d7d5fa67ee6b4bfc4f6d1fe91038338 as base

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
