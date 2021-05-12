FROM docker.io/yolean/ystack-runner:237150c3aae8404ebd3625dcda48aad09ff219e7@sha256:54fd6b3458cd863feb3559e967951c42adb52366ac74a99845a1ef59571a6178

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
