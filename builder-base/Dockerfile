FROM solsson/ystack-runner@sha256:52e5b2b46e334c205a427681714a233d4eb728631c66cc6f0a8db8f858f0deca

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
