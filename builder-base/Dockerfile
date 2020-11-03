FROM docker.io/solsson/ystack-runner:2ed4bdc392fe01fa8536a25bb6747ddf1b3f9432@sha256:2b0df5d9f1b033ccdd757a1671c1b5248931d7d2d18ef5b15f33a03694f052e9

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
