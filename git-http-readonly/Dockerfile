FROM httpd:2.4.51-bullseye@sha256:f70876d78442771406d7245b8d3425e8b0a86891c79811af94fb2e12af0fadeb

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='gitweb libhttp-date-perl'; \
  buildDeps=''; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

RUN echo 'nonroot:x:65532:65534:nonroot:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot
USER nonroot:nogroup
