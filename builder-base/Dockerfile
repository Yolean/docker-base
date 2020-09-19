FROM solsson/ystack-runner:bf12f5bdf7af8fa9becf811bb99c6d07553f0653@sha256:9c2aca707f1c8bda979e7350058c9c1b3703fae2ee5cfa7fa5eb24f32a2b7e34

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
