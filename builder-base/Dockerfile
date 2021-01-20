FROM docker.io/solsson/ystack-runner:c74024b221593abf602484519fb87f5793a939dd@sha256:5a3b22a006dd3e16c1963d6a96436e69fb103b4cc11586a485418bd0177ebc35

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
