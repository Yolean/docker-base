FROM docker.io/solsson/ystack-runner:a128d7028c7857c1dec008fa0c8b65111193506d@sha256:9d1de12426d354b71a2c30afce19df6bb0e71603cebbe884337ad50c45b1030f

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
