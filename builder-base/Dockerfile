FROM docker.io/yolean/ystack-runner:a5c9d6f38a4899e3291ffe678a808c91bc7f729d@sha256:a0a408854fd2d626a520859adfae18cab93370e0b2f8dbc2d05a534145ab0f3b

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
