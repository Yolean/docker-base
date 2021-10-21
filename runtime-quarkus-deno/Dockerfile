FROM yolean/builder-base as base

RUN y-deno -V

FROM yolean/runtime-quarkus-ubuntu

COPY --from=base \
  /usr/local/src/ystack/bin/deno /usr/local/bin/deno
