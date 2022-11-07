FROM httpd:2.4.52-bullseye@sha256:0954cc1af252d824860b2c5dc0a10720af2b7a3d3435581ca788dff8480c7b32

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
