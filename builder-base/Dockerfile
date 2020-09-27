FROM docker.io/solsson/ystack-runner:669345d9145ecfb45e060c799edd252b69211a0c@sha256:c2ae3dabfe8d526c87ad5afcd1c622fcc476bf07efdc2710fd9d886afe33311f

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
