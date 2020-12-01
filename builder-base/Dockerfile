FROM docker.io/solsson/ystack-runner:6e2d94d6a64aa64c65eef5d91989ac0d9fef488a@sha256:0b39d24e573663b350d43878036055023febea58cc052ca0cd685e678ff8b19c

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
