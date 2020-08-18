FROM solsson/ystack-runner:c9cefb76421ecda7114c9cca3a00cbbde7276fae@sha256:5d253eb7ce22b37b52b74b737059c3d8d08234ed746e50278db1e744b8ac3886

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
