FROM solsson/ystack-runner@sha256:09ade04bbd0cc6532697e16f46b8146b042f5b7cd8d878990922aba198ad64f2

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
