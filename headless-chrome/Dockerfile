FROM ubuntu:22.04@sha256:a9038002b9b29c77c93b1c562ca2bee51313c6f5208c8d90b91929db62e96930
ARG chrome_stage=stable
ARG chrome_build=118.0.5993.70-1

ENV CHROME_VERSION="${chrome_stage}=${chrome_build}"

# Install deps + add Chrome Stable + purge all the things
RUN runtimeDeps='procps ca-certificates' \
  && buildDeps='apt-transport-https curl gnupg' \
  && set -ex \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends \
  && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update \
  && apt-get -s install google-chrome-stable | grep chrome \
  && apt-get -s install google-chrome-beta | grep chrome \
  && apt-get install -y \
    google-chrome-$CHROME_VERSION \
    --no-install-recommends \
  && apt-get purge -y --auto-remove $buildDeps \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

RUN grep 'nonroot:x:65532' /etc/passwd || \
  echo 'nonroot:x:65532:65534:nonroot:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot && \
  usermod -a -G audio,video nonroot
USER nonroot:nogroup

EXPOSE 9222

ENTRYPOINT [ "google-chrome" ]
CMD [ "--headless=new", \
  "--disable-gpu", \
  "--remote-debugging-address=0.0.0.0", \
  "--remote-debugging-port=9222", \
  "--safebrowsing-disable-auto-update", \
  "--disable-background-networking", \
  "--disable-extensions", \
  "--disable-translate", \
  "--disable-sync", \
  "--user-data-dir=/home/nonroot/userdata", \
  "--enable-logging", \
  "--v=2" ]
