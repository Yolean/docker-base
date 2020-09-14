FROM solsson/ystack-runner:3c16b67ac1929e0566ca39d6f9500363ccb00220@sha256:6925026846d13dbaa5abd635e64f2f6a6697023afdc9cdaf538a6925f185a55c

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
