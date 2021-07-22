FROM docker.io/yolean/ystack-runner:78f38ab63c6de4ae96f364609cf1ff9f8900f283@sha256:445ed12afcd3ca0755a786b502a4b5dcdfc5c3f8b70fa232a089534a50110a33

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
