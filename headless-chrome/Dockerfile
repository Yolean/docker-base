# Run Chrome Headless in a container
#
# What was once a container using the experimental build of headless_shell from
# tip, this container now runs and exposes stable Chrome headless via
# google-chome --headless.
#
# What's New
#
# 1. Pulls from Chrome Stable
# 2. You can now use the ever-awesome Jessie Frazelle seccomp profile for Chrome.
#     wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json -O ~/chrome.json
#
#
# To run (without seccomp):
# docker run -d -p 9222:9222 --cap-add=SYS_ADMIN justinribeiro/chrome-headless
#
# To run a better way (with seccomp):
# docker run -d -p 9222:9222 --security-opt seccomp=$HOME/chrome.json justinribeiro/chrome-headless
#
# Basic use: open Chrome, navigate to http://localhost:9222/
#

# Base docker image
FROM ubuntu:22.04@sha256:20fa2d7bb4de7723f542be5923b06c4d704370f0390e4ae9e1c833c8785644c1
ARG chrome_stage=stable
ARG chrome_build=106.0.5249.119-1

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

# Add Chrome as a user
RUN usermod -a -G audio,video nobody \
  && mkdir -p /home/nobody && chown -R nobody:nogroup /home/nobody

# Fixes startup warning mkdir: cannot create directory '/nonexistent': Permission denied
RUN mkdir /nonexistent && chown nobody:nogroup /nonexistent

# Run Chrome non-privileged
USER nobody:nogroup

# Expose port 9222
EXPOSE 9222

# Autorun chrome headless with no GPU
ENTRYPOINT [ "google-chrome" ]
CMD [ "--headless", \
  "--disable-gpu", \
  "--remote-debugging-address=0.0.0.0", \
  "--remote-debugging-port=9222", \
  "--safebrowsing-disable-auto-update", \
  "--disable-background-networking", \
  "--disable-extensions", \
  "--disable-translate", \
  "--disable-sync", \
  "--user-data-dir=/home/nobody/userdata", \
  "--enable-logging", \
  "--v=2" ]
