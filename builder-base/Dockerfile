FROM docker.io/solsson/ystack-runner:d12d1f9fb892f930d546943743ea870345d480a1@sha256:9d5b5454811693a0c8c4f81dcaf7f117a217b4095ee69b776965399296e6e7ec

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
