FROM yolean/builder-quarkus as libs

FROM gcr.io/distroless/base-debian10:nonroot@sha256:4734b55c73dc008f59e4f6b0275e6a1b2840d8db70f6a89c59c8fc23e1c6edd0

COPY --from=libs \
  /usr/lib/x86_64-linux-gnu/libgcc_s.so.* \
  /usr/lib/x86_64-linux-gnu/

COPY --from=libs \
  /usr/local/src/ystack/bin/deno /deno

ENTRYPOINT ["/deno"]
CMD ["-V"]
