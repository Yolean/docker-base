FROM --platform=$TARGETPLATFORM yolean/node:177518b0a77298d34f0caf1d0fcdc13750c355a8-root

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='python3 google-cloud-cli rsync unzip'; \
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

RUN set -ex; \
  mkdir /opt/protobuf; \
  cd /opt/protobuf; \
  curl -sL -o protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/v25.1/protoc-25.1-linux-x86_64.zip; \
  unzip protoc.zip; \
  ln -s /opt/protobuf/bin/protoc /usr/local/bin/protoc; \
  rm protoc.zip
