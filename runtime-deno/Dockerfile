FROM yolean/builder-quarkus as libs

RUN y-deno -V

FROM gcr.io/distroless/base-debian10:nonroot@sha256:ccbc79c4fc35b92709d3987315cdb9e20b6e742546af7a7db10024641aa60572

COPY --from=libs \
  /usr/lib/x86_64-linux-gnu/libgcc_s.so.* \
  /usr/lib/x86_64-linux-gnu/

COPY --from=libs \
  /usr/local/src/ystack/bin/deno /deno

ENTRYPOINT ["/deno"]
CMD ["-V"]
