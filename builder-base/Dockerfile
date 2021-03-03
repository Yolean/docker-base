FROM docker.io/yolean/ystack-runner:613d57c58678dc9d6b83b774377ffed75c8e6ed1@sha256:106df944cf0d94e6bccef48513fbecd615166e98ff4982d7fcb044f9ee9c4ef1

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
