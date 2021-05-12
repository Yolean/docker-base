FROM adoptopenjdk:11.0.11_9-jre-hotspot-focal@sha256:159de1ea7c06ae8fbfcdda68a1ddf352778364ef2fc61b095923f075766c99e2

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='libsnappy1v5 libsnappy-jni liblz4-1 liblz4-jni libzstd1'; \
  apt-get update && apt-get install -y $runDeps --no-install-recommends; \
  \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg
