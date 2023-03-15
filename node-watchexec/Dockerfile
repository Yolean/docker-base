# syntax=docker/dockerfile:1.4

# This is a messy dockerfile because it explores options for evolving our nodejs base
# Once an option has been selected it should be short

# Should correspond to builder-base, i.e. be updated with new ystack-runner
FROM --platform=$TARGETPLATFORM ubuntu:22.04@sha256:9a0bdde4188b896a372804be2384015e90e3f84906b750c1a53539b585fbbe7f \
  as base
FROM --platform=$TARGETPLATFORM node:18.15.0-bullseye-slim@sha256:7d67f2765f8d1b13f3833001bebbc6513581ef3f300aa4b1019a0b6dff2c0b25 \
  as node

# Both the official node image and github.com/GoogleContainerTools/distroless run bullseye
# with an official glibc version that's too old for release binaries from https://github.com/watchexec/watchexec/releases
FROM --platform=$TARGETPLATFORM node as build

WORKDIR /workspace
RUN apt-get update
RUN apt-get install -y --no-install-recommends curl ca-certificates
RUN curl -o rustup.sh --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs
RUN sh ./rustup.sh -y

RUN apt-get install -y --no-install-recommends gcc libc-dev

ARG watchexecVersion=1.21.1
# Fails on Compiling git-ref v0.22.0: error[E0277]: the trait bound `BStr: AsRef<[_; 0]>` is not satisfied
# RUN $HOME/.cargo/bin/cargo install watchexec-cli@${watchexecVersion}

# ystack-runner already depends on official node's layers on top of ubuntu, i.e. newer glibc
FROM --platform=$TARGETPLATFORM base as base-node-watchexec-release
COPY --from=node --link /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node --link /usr/local/bin/node /usr/local/bin/

ARG watchexecVersion=1.21.1

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps=' \
    libc6 \
  '; \
  buildDeps=' \
    curl ca-certificates \
    xz-utils \
  '; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  mkdir /opt/watchexec; cd /opt/watchexec; \
  export arch=$(uname -m); \
  curl -o watchexec.tar.xz -sLSf \
     "https://github.com/watchexec/watchexec/releases/download/v${watchexecVersion}/watchexec-${watchexecVersion}-$arch-unknown-linux-gnu.tar.xz"; \
  tar -xvJf watchexec.tar.xz --strip-components=1; \
  mv watchexec /usr/local/bin/watchexec; \
  rm -r /opt/watchexec; \
  \
  [ -z "$buildDeps" ] || apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log /root/.gnupg;

ENTRYPOINT [ "/usr/local/bin/watchexec", \
  "--print-events", \
  "--debounce=500", \
  "--shell=none", \
  "--watch=/app", \
  "-r", \
  "--", \
  "/usr/local/bin/node" ]

# Make compatible with node-distroless
WORKDIR /app
CMD [ "--enable-source-maps", "./main.js" ]

# Current default target
FROM --platform=$TARGETPLATFORM base-node-watchexec-release
