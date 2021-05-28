FROM docker.io/yolean/ystack-runner:688df86bc78429f68dd8c43087b1792f6bce00e6@sha256:4eba87ee89c85477224b3fe674f40c2f8666f31b18fb8f44acbcdb0acefce27e

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
