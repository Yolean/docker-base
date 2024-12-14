FROM --platform=$TARGETPLATFORM google/cloud-sdk:slim as cloud-sdk

RUN ls -l /usr/lib/google-cloud-sdk \
  && ls -l /usr/lib/google-cloud-sdk/platform \
  && cd /usr/lib/google-cloud-sdk && rm -rf \
    platform/anthoscli_licenses \
    platform/bq \
    platform/bundledpythonunix \
    platform/ext-runtime \
    lib/googlecloudsdk/appengine

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

COPY --from=cloud-sdk /usr/lib/google-cloud-sdk /usr/lib/google-cloud-sdk
COPY --from=cloud-sdk /root/.config/gcloud /home/nonroot/.config/gcloud

ENV PATH="${PATH}:/usr/lib/google-cloud-sdk/bin"

RUN gsutil version
