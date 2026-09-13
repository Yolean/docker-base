FROM --platform=$TARGETPLATFORM ghcr.io/yolean/ystack-runner:5ddd6b7ad5ae1df8fa0e61dc637e1e67777cc393@sha256:e9181f5d619cd3bf30b023bbf9792e3d57ad3cfd1b256937966a680aa47c7d8d \
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
RUN npm install -g --ignore-scripts pnpm@12.4.1 && node "$(npm root -g)/pnpm/install.js"
USER nonroot:nogroup

