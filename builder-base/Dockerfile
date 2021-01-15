FROM docker.io/solsson/ystack-runner:93aaf8f6fcc50a57afb6998f28a231c12ac55195@sha256:5b75d105c64e2e43516ebaaa11bad44b4025aa59c4bc62fec8a91c276f4ed402

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
