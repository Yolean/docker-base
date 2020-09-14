FROM solsson/ystack-runner:3c16b67ac1929e0566ca39d6f9500363ccb00220@sha256:5f22dbb7cffe7d381afcb327ee1ade5aeef658642f46995ebc3d3b5eef930a5a

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
