# For JNI/snappy such as kafka clients use runtime-quarkus-ubuntu instead

FROM gcr.io/distroless/base-debian10:nonroot@sha256:ccbc79c4fc35b92709d3987315cdb9e20b6e742546af7a7db10024641aa60572

ENTRYPOINT ["/usr/local/bin/quarkus", "-Djava.util.logging.manager=org.jboss.logmanager.LogManager"]
CMD ["-Dquarkus.http.host=0.0.0.0", "-Dquarkus.http.port=8080"]

# What should remain now is to copy the native binary to /usr/local/bin/quarkus
