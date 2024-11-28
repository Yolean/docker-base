FROM yolean/runtime-deno AS runtime-deno

FROM yolean/runtime-quarkus-ubuntu

COPY --from=runtime-deno \
  /usr/local/bin/deno /usr/local/bin/deno
