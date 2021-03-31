# ystack/runner
FROM ubuntu:20.04@sha256:a15789d24a386e7487a407274b80095c329f89b1f830e8ac6a9323aa61803964

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='libsnappy1v5 libsnappy-jni liblz4-1 libzstd1'; \
  apt-get update && apt-get install -y $runDeps --no-install-recommends; \
  \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

ENTRYPOINT ["/usr/local/bin/quarkus", "-Djava.util.logging.manager=org.jboss.logmanager.LogManager"]
CMD ["-Dquarkus.http.host=0.0.0.0", "-Dquarkus.http.port=8080"]
