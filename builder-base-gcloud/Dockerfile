# based on https://hub.docker.com/r/google/cloud-sdk this seems to be the only debian based tag that supports arm
#FROM --platform=$TARGETPLATFORM google/cloud-sdk:debian_component_based as cloud-sdk
FROM --platform=$TARGETPLATFORM google/cloud-sdk:slim as cloud-sdk

# RUN mv /google-cloud-sdk /google-cloud-sdk-full \
#   && mkdir -p /google-cloud-sdk/bin \
#   && cp /google-cloud-sdk-full/bin/gsutil /google-cloud-sdk/bin/ \
#   && gsutil version && false

FROM --platform=$TARGETPLATFORM yolean/builder-base

USER root
RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='python3 rsync openssh-client'; \
  \
  apt-get update && apt-get install -y --no-install-recommends $runDeps $buildDeps; \
  \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg
USER nonroot:nogroup

COPY --from=cloud-sdk /usr/lib/google-cloud-sdk/platform/gsutil /usr/local/gsutil
COPY --from=cloud-sdk /usr/lib/google-cloud-sdk/platform/bundledpythonunix /usr/local/bundledpythonunix

ENV PATH="${PATH}:/usr/local/gsutil"

RUN gsutil version
