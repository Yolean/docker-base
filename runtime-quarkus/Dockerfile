FROM registry.access.redhat.com/ubi8/ubi-minimal:8.1@sha256:df6f9e5d689e4a0b295ff12abc6e2ae2932a1f3e479ae1124ab76cf40c3a8cdd

# Like ubuntu
RUN echo 'nogroup:x:65534:' | tee -a /etc/group

# Same as github.com/solsson/dockerfiles/tree/master/kafka-nonroot, and ystack's runner.Dockerfile
RUN echo 'nonroot:x:65532:65534:nonroot:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot
USER nonroot:nogroup

ENTRYPOINT ["/usr/local/bin/runner", "-Djava.util.logging.manager=org.jboss.logmanager.LogManager"]
CMD ["-Dquarkus.http.host=0.0.0.0", "-Dquarkus.http.port=8080"]

# What should remain now is to copy the native binary to /usr/local/bin/runner
