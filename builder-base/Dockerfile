FROM docker.io/solsson/ystack-runner:cc6234b863b09ec9272c598d5a2431f9f11b0317@sha256:ffc2b8ac771af99c9a9dc4215f72285d33bdb318be58d2bb630e4e33266e69d8

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
