FROM yolean/builder-quarkus as libs

RUN y-deno -V

FROM --platform=$TARGETPLATFORM gcr.io/distroless/static-debian12:nonroot@sha256:aa09b5ebfd7181b30717b95a057557389135ac4df8aa78dd07ab8b50ca9954c6

COPY --from=libs \
  /usr/lib/x86_64-linux-gnu/libgcc_s.so.* \
  /usr/lib/x86_64-linux-gnu/

COPY --from=libs \
  /usr/local/src/ystack/bin/deno /deno

ENTRYPOINT ["/deno"]
CMD ["-V"]
