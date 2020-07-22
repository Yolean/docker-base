FROM solsson/ystack-runner@sha256:55eaeb5cb07bb306ff805bf822226ae81cf2280f089765c7fdcb0eee15267d75

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
