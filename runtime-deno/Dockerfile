FROM yolean/builder-quarkus as libs

RUN y-deno -V

FROM gcr.io/distroless/static-debian11:nonroot@sha256:80c956fb0836a17a565c43a4026c9c80b2013c83bea09f74fa4da195a59b7a99

COPY --from=libs \
  /usr/lib/x86_64-linux-gnu/libgcc_s.so.* \
  /usr/lib/x86_64-linux-gnu/

COPY --from=libs \
  /usr/local/src/ystack/bin/deno /deno

ENTRYPOINT ["/deno"]
CMD ["-V"]
