FROM docker.io/solsson/ystack-runner:88b1f4b0e0fb9a627bcb68047c10a933ce80fd04@sha256:36da6eba5adbfcbcafa907f6cb0f432facde05652faf0bfe2a65ee847a2f50a2

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
