FROM docker.io/solsson/ystack-runner:1addee566fc685df8f826b1387a1826c7c5a2f8a@sha256:e377b0a99e59a7ca7cbed4c2b5562fa556e4ccdde08ddca0c8e054df98e45c66

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
