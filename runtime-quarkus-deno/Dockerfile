FROM yolean/builder-base as base

FROM yolean/runtime-quarkus

COPY --from=base \
  /usr/local/src/ystack/bin/deno /deno
