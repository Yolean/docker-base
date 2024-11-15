FROM yolean/builder-quarkus as libs

RUN y-deno -V

FROM --platform=$TARGETPLATFORM gcr.io/distroless/static-debian12:nonroot@sha256:d71f4b239be2d412017b798a0a401c44c3049a3ca454838473a4c32ed076bfea

COPY --from=libs \
  /usr/lib/x86_64-linux-gnu/libgcc_s.so.* \
  /usr/lib/x86_64-linux-gnu/

COPY --from=libs \
  /usr/local/src/ystack/bin/deno /deno

ENTRYPOINT ["/deno"]
CMD ["-V"]
