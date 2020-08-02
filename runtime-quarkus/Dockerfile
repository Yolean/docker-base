FROM debian:10-slim@sha256:44d9b596776ea4efe559079b8ec35422e1b6abcc4de6e211b0085480d76df3bf as libs

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='ca-certificates libsnappy1v5 liblz4-1 libzstd1'; \
  apt-get update && apt-get install -y $runDeps --no-install-recommends; \
  \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

FROM gcr.io/distroless/base-debian10:nonroot@sha256:78f2372169e8d9c028da3856bce864749f2bb4bbe39c69c8960a6e40498f8a88

COPY --from=libs \
  /lib/x86_64-linux-gnu/libz.so.* \
  /lib/x86_64-linux-gnu/

COPY --from=libs \
  /usr/lib/x86_64-linux-gnu/libzstd.so.* \
  /usr/lib/x86_64-linux-gnu/libsnappy.so.* \
  /usr/lib/x86_64-linux-gnu/liblz4.so.* \
  /usr/lib/x86_64-linux-gnu/

ENTRYPOINT ["/usr/local/bin/runner", "-Djava.util.logging.manager=org.jboss.logmanager.LogManager"]
CMD ["-Dquarkus.http.host=0.0.0.0", "-Dquarkus.http.port=8080"]

# What should remain now is to copy the native binary to /usr/local/bin/runner
