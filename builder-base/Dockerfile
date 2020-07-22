FROM solsson/ystack-runner@sha256:069e8792c02e2071f2fc8979978ca122c4353c15a7d7fcc61e724917c101608e

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
