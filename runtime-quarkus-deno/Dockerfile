FROM --platform=$TARGETPLATFORM yolean/runtime-deno AS runtime-deno

FROM --platform=$TARGETPLATFORM yolean/runtime-quarkus-ubuntu

COPY --from=runtime-deno \
  /usr/local/bin/deno /usr/local/bin/deno
