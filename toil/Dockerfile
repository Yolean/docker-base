FROM ubuntu:19.04

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='ca-certificates git curl kafkacat jq procps'; \
  buildDeps='gnupg2'; \
  apt-get update; \
  apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -; \
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list; \
  apt-get update; \
  apt-get install -y kubectl; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /etc/ssl/certs /root/.gnupg

ENTRYPOINT [ "/bin/bash" ]
