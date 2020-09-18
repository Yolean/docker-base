FROM solsson/ystack-runner:4709e6a1d5ca3bbd8f2de87e89499b9d96b07770@sha256:5a8d37149ad1977fbbde267b43844fbfab63d4e0613de5543f42c8cd48b1cebb

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
