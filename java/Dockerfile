FROM adoptopenjdk:11.0.10_9-jre-hotspot-focal@sha256:c365d39341f54bd64f4eadce7aa2f2251743dba4bfb7bd2e0a6fc7b76eeba25e

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='libsnappy1v5 libsnappy-jni liblz4-1 liblz4-jni libzstd1'; \
  apt-get update && apt-get install -y $runDeps --no-install-recommends; \
  \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg
