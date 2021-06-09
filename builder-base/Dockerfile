FROM docker.io/yolean/ystack-runner:fd0998d9894324ad1cbead6fb768c060db9cf5ff@sha256:3630f5bf882ec7edbef6fdc50a5c10537877a6ab7e0dd2d2779f297add85285a

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
