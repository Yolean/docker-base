FROM docker.io/solsson/ystack-runner:29bd8cdf20a75f066ceb42bddd5920490d438086@sha256:43de2ffdfc73318b0928289af59f7b472d05a5b20a9f0c9805118245e9b263fe

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
