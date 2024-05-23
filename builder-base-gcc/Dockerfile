FROM --platform=$TARGETPLATFORM yolean/builder-base

# This image keeps buildDeps for runtime, used by native compile

USER root
RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='libsnappy1v5 libsnappy-jni liblz4-1 liblz4-jni libzstd1 libfreetype6 fontconfig'; \
  buildDeps='gcc g++ libc-dev make zlib1g-dev libsnappy-dev liblz4-dev libzstd-dev libfreetype6-dev'; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg
USER nonroot:nogroup
