FROM docker.io/solsson/ystack-runner:f5513329e1fcfbc6d7a54ee71e852924df58ba9f@sha256:6d116858b1169ded73f86508d2371b10b6cf36e9589501eae922dd0d898f9f4d

ENV CI=true

USER root

RUN mkdir /workspace && chgrp nogroup /workspace && chmod g+w /workspace
WORKDIR /workspace

USER nonroot:nogroup
