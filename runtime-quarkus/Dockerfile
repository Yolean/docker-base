# For JNI/snappy such as kafka clients use runtime-quarkus-ubuntu instead

FROM gcr.io/distroless/static-debian11:nonroot@sha256:66cd130e90992bebb68b8735a72f8ad154d0cd4a6f3a8b76f1e372467818d1b4

ENTRYPOINT ["/usr/local/bin/quarkus", "-Djava.util.logging.manager=org.jboss.logmanager.LogManager"]
CMD ["-Dquarkus.http.host=0.0.0.0", "-Dquarkus.http.port=8080"]

# What should remain now is to copy the native binary to /usr/local/bin/quarkus
