FROM yolean/builder-quarkus as libs

FROM gcr.io/distroless/base-debian10:nonroot@sha256:4734b55c73dc008f59e4f6b0275e6a1b2840d8db70f6a89c59c8fc23e1c6edd0

COPY --from=libs \
  /usr/lib/x86_64-linux-gnu/libgcc_s.so.* \
  /usr/lib/x86_64-linux-gnu/libz.so.* \
  /usr/lib/x86_64-linux-gnu/libstdc++.so.* \
  /usr/lib/x86_64-linux-gnu/libzstd.so.* \
  /usr/lib/x86_64-linux-gnu/libsnappy.so.* \
  /usr/lib/x86_64-linux-gnu/liblz4.so.* \
  /usr/lib/x86_64-linux-gnu/

ENTRYPOINT ["/usr/local/bin/quarkus", "-Djava.util.logging.manager=org.jboss.logmanager.LogManager"]
CMD ["-Dquarkus.http.host=0.0.0.0", "-Dquarkus.http.port=8080"]

# What should remain now is to copy the native binary to /usr/local/bin/quarkus
