FROM docker.io/solsson/ystack-runner:5737fdfe08752983fbd3c9bc8a5e8d4ec427186e@sha256:df936cd09a833ee42387a4080dd4fc0b1c455c3c2f0f42ba753d3bcd3092718f

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
