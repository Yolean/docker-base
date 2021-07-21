FROM docker.io/yolean/ystack-runner:8031d8875b710d77447230e8b6a228ec73b1198e@sha256:e7d40ca754205e0dba1a31d59b783a26dd1d5d658ba8e44faaec0d3aa66cacfd

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
