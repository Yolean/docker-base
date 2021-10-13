# For JNI/snappy such as kafka clients use runtime-quarkus-ubuntu instead

FROM gcr.io/distroless/static-debian10:nonroot@sha256:842501a445a646c01189da2a4249b0b1ab511049f212534e49276f5a168efed4

ENTRYPOINT ["/usr/local/bin/quarkus", "-Djava.util.logging.manager=org.jboss.logmanager.LogManager"]
CMD ["-Dquarkus.http.host=0.0.0.0", "-Dquarkus.http.port=8080"]

# What should remain now is to copy the native binary to /usr/local/bin/quarkus
