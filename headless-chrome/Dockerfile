FROM ubuntu:22.04@sha256:67211c14fa74f070d27cc59d69a7fa9aeff8e28ea118ef3babc295a0428a6d21
ARG chrome_stage=stable
ARG chrome_build=112.0.5615.165-1

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
