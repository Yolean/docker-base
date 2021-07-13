FROM docker.io/yolean/ystack-runner:37bf352fb44c88fb1b318be9ca0c414ff1fe6b53@sha256:da527acf974a1f19226bb760a8734f50a8d0924615a54383e2ac0f8d420ec1f9

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
