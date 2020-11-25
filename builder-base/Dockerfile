FROM docker.io/solsson/ystack-runner:d8dc59efadbbd56a2c5d20e949e0848c71b8cd19@sha256:89b5c9bccc31823b6b54c82d846581d4b24ced11cda225718775b15d75b77d33

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
