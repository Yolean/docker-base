# For JNI/snappy such as kafka clients use runtime-quarkus-ubuntu instead

FROM gcr.io/distroless/static-debian11:nonroot@sha256:80c956fb0836a17a565c43a4026c9c80b2013c83bea09f74fa4da195a59b7a99

ENTRYPOINT ["/usr/local/bin/quarkus", "-Djava.util.logging.manager=org.jboss.logmanager.LogManager"]
CMD ["-Dquarkus.http.host=0.0.0.0", "-Dquarkus.http.port=8080"]

# What should remain now is to copy the native binary to /usr/local/bin/quarkus
