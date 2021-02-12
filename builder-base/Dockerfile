FROM docker.io/solsson/ystack-runner:a58c15895b4a603d2af89b9fe5b65f17ef47caf6@sha256:a25a08ef57cb88977fe9be064771de2fd23267a064bd46563218e184d8822083

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

RUN chown nonroot /usr/local/src/ystack/bin

USER nonroot:nogroup
