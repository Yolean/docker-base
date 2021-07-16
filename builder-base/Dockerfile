FROM docker.io/yolean/ystack-runner:16a181f23e68556f57433626ecbd7f938b3e3321@sha256:771e12e11bebc0cd66ae34d783fa75564f8ebd216c5ed2a9ad79118b346b9412

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
