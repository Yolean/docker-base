FROM docker.io/solsson/ystack-runner:1fa25af8c9d5d47038d0b80a30c15c862aa84893@sha256:c8cf7cb975f9ec95025941de3707452068038e473a8f3a8949a403462a268f8b

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
