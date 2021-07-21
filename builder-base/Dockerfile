FROM docker.io/yolean/ystack-runner:fc40c4ea8ef1a6c15d9324ffa9320fb6d1cb3d64@sha256:9084f680dabe7e43a8f72a12f9aa09245845eafa7d4d01829bb2645f8bada5aa

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
