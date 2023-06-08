FROM --platform=$TARGETPLATFORM yolean/builder-base

USER root
RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='python3 google-cloud-cli rsync'; \
  buildDeps='gnupg2'; \
  \
  apt-get update && apt-get install -y --no-install-recommends $buildDeps; \
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list; \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor > /usr/share/keyrings/cloud.google.gpg; \
  \
  apt-get update && apt-get install -y --no-install-recommends $runDeps $buildDeps; \
  gcloud version; \
  gsutil version; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg
USER nonroot:nogroup
