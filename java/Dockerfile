FROM adoptopenjdk:11.0.11_9-jre-hotspot-focal@sha256:1d8c1bf39aed8e5fc738bb26443e8c9693fe0e1a1fac2374a478b1070d149ba3

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='libsnappy1v5 libsnappy-jni liblz4-1 liblz4-jni libzstd1'; \
  apt-get update && apt-get install -y $runDeps --no-install-recommends; \
  \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg
