FROM httpd:2.4.55-bullseye@sha256:87a012bf99bf5e3e0f628ac1f69abbeab534282857fba3a359ca3a3f4a02429a

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='gitweb libhttp-date-perl'; \
  buildDeps=''; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

COPY httpd.conf conf/httpd.conf
COPY extra/* conf/extra/

VOLUME /srv/git

RUN echo 'nonroot:x:65532:65534:nonroot:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot && \
  chown nonroot /usr/local/apache2/logs
USER nonroot:nogroup
