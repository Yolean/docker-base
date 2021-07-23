FROM docker.io/yolean/ystack-runner:581f851c4796894b6154aa584a120727588aa3ca@sha256:54f2cb9d6ab92cee31dd2f1ac45d54423414d7e61fe280f5878d4c01499a9eed

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
