FROM docker.io/yolean/ystack-runner:bf80d992e97802a5052029e43d8d9b06f597ed4c@sha256:6865216cf9033fd4aae22b3482f1c8a01956fdfcfefe4ddc55619db423b53342

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
