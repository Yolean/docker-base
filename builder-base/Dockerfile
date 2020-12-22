FROM docker.io/solsson/ystack-runner:b005dc1e8ad1e30aa7072194823025e13336a66a@sha256:f399ee3caecc86e3945fbfcc3dbb40193c348f206adb8283226c232b63a21ef6

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
