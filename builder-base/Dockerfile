FROM solsson/ystack-runner@sha256:912a844a8e4bf67da6134036944a33de403d07e5b3d33b58bd624ac037b3bcf7

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
