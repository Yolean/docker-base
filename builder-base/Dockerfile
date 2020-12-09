FROM docker.io/solsson/ystack-runner:e31e7065bbca22f4882168d95154dbeec890a3e0@sha256:7bc5669759d658d55868f53a3ab69482ffef73a330fe522f65362fc24648fcf8

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
