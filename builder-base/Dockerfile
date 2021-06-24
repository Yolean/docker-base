FROM docker.io/yolean/ystack-runner:6be9ec5eb04edf6cc1f670a4d556ca408916e564@sha256:dc2b930963699ff0ca45876911c25ac38631754b779db71bb1806e2de5b3b044

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
