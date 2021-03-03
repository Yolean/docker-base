FROM yolean/builder-base as base

RUN y-deno -V

FROM yolean/runtime-quarkus

COPY --from=base \
  /usr/local/src/ystack/bin/deno /deno
