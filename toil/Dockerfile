FROM ubuntu:19.04@sha256:1f070d23781c4e0aa3841ae9d7494885283e199e61eddec8337cd1895f864d67

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='ca-certificates git curl kafkacat jq procps'; \
  buildDeps='gnupg2'; \
  apt-get update; \
  apt-get install -y --no-install-recommends $runDeps $buildDeps; \
  \
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -; \
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list; \
  apt-get update; \
  apt-get install -y kubectl; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

ENTRYPOINT [ "/bin/bash" ]
