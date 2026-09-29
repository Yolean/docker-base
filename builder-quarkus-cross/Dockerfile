# builder-quarkus that also compiles Quarkus native images for linux/arm64, on amd64:
# native-image --target=linux-aarch64 with an x86_64 -> aarch64 gcc, so no arm64 node and no
# emulation at build time. amd64 only (SINGLE_ARCH_AMD64). Use through y-native-image.

# Only the parts a cross build needs from arm64: Mandrel's aarch64 static libs, zlib, and the CAP cache.
FROM --platform=linux/arm64 yolean/builder-quarkus AS arm64

# CAP cache: the C constants and struct layouts native-image normally gets by compiling and
# running small programs for the target, which a cross build cannot run. Generated here on arm64
# (under QEMU in CI, a few minutes). Keyed by the directive classes an app reaches: the JDK's via
# CapProbe, plus smallrye-common-net's Substitutions$NativeInfoDirectives, which every Quarkus app
# carries. A cross build that reaches a directive missing here fails at startup with
# "Could not load CAPCache file", never with a wrong binary; add the library to the probe then.
ARG SMALLRYE_COMMON_NET_VERSION=2.17.0
ARG SMALLRYE_COMMON_NET_SHA256=daabecc170bd111a65a81c8a08a05975d48acab566a292d99ada6a78aa4a9712
COPY --chown=nonroot:nogroup CapProbe.java /home/nonroot/
RUN set -ex; \
  mkdir /home/nonroot/capprobe; \
  mv /home/nonroot/CapProbe.java /home/nonroot/capprobe/; \
  cd /home/nonroot/capprobe; \
  curl -o smallrye-common-net.jar -sLSf https://repo1.maven.org/maven2/io/smallrye/common/smallrye-common-net/$SMALLRYE_COMMON_NET_VERSION/smallrye-common-net-$SMALLRYE_COMMON_NET_VERSION.jar; \
  echo "$SMALLRYE_COMMON_NET_SHA256  smallrye-common-net.jar" | sha256sum -c -; \
  javac CapProbe.java; \
  native-image -cp .:smallrye-common-net.jar CapProbe \
    -H:+UnlockExperimentalVMOptions -H:+NewCAPCache -H:+ExitAfterCAPCache -H:CAPCacheDir=/home/nonroot/capcache; \
  test -s /home/nonroot/capcache/PosixDirectives.cap; \
  test -f /home/nonroot/capcache/Substitutions_NativeInfoDirectives.cap; \
  mkdir -p /home/nonroot/cross/lib /home/nonroot/cross/include; \
  cp -a /usr/lib/aarch64-linux-gnu/libz.* /home/nonroot/cross/lib/; \
  cp -a /usr/include/zlib.h /usr/include/zconf.h /home/nonroot/cross/include/

FROM --platform=$TARGETPLATFORM yolean/builder-quarkus

USER root
# Same Ubuntu release as the arm64 builder, so the cross glibc is the one a native arm64 build links
RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  apt-get update && apt-get install -y --no-install-recommends \
    gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu libc6-dev-arm64-cross; \
  \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg
COPY --from=arm64 /home/nonroot/cross/ /usr/aarch64-linux-gnu/
COPY --from=arm64 /opt/mandrel/lib/static/linux-aarch64 /opt/mandrel/lib/static/linux-aarch64
COPY --from=arm64 /opt/mandrel/lib/svm/clibraries/linux-aarch64 /opt/mandrel/lib/svm/clibraries/linux-aarch64
COPY --from=arm64 /home/nonroot/capcache /opt/native-image-cross/linux-aarch64/capcache
COPY y-native-image /usr/local/bin/

# Proves the toolchain end to end: a cross-compiled probe must come out as an AArch64 executable
COPY --from=arm64 /home/nonroot/capprobe /tmp/capprobe
RUN set -ex; \
  cd /tmp/capprobe; \
  y-native-image --platform=linux/arm64 -cp .:smallrye-common-net.jar CapProbe -o capprobe; \
  aarch64-linux-gnu-readelf -h capprobe | grep -q 'Machine:.*AArch64'; \
  cd /; rm -rf /tmp/capprobe

USER nonroot:nogroup
