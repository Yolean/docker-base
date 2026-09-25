FROM --platform=$TARGETPLATFORM ghcr.io/yolean/ystack-runner:e9d5d661470cfe0cb86986e5c561b2cd2481d921@sha256:3122668112a80f4b4bd81f6fd117e155df64f1d3c4af20e0c8b6389613f8cb2e \
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
# --ignore-scripts blocks pnpm's own postinstall, which hardlinks the real native
# binary over the shebang-less placeholder it ships at this path; without it, the
# placeholder stays, and turbo (spawning via execve, not a shell) can't recover
# from it the way a shell silently does on ENOEXEC.
RUN npm install -g --ignore-scripts pnpm@12.6.0 && node "$(npm root -g)/pnpm/install.js"
USER nonroot:nogroup

