FROM yolean/builder-quarkus as libs

FROM gcr.io/distroless/base-debian10:nonroot@sha256:f4a1b1083db512748a305a32ede1d517336c8b5bead1c06c6eac2d40dcaab6ad

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

COPY --from=libs \
  /usr/local/src/ystack/bin/deno /deno

# What should remain now is to copy the native binary to /usr/local/bin/quarkus
