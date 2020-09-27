FROM yolean/builder-quarkus as builder-graalvm-without-rm

USER root
# should be the same as builder-quarkus, minus the rm:s
RUN set -ex; \
  mkdir /opt/graalvm-full; \
  curl -sLS $graalvm_dist | \
    tar xzf - --strip-components=1 -C /opt/graalvm-full

FROM yolean/builder-quarkus

COPY --from=builder-graalvm-without-rm /opt/graalvm-full/lib/polyglot /opt/graalvm/lib/polyglot
# note that visualvm and tools have also been removed from builder-quarkus
