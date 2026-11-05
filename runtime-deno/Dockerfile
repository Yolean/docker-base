FROM --platform=$TARGETPLATFORM denoland/deno:distroless-2.1.1@sha256:8c7fbba4e216e9535ac9869744ce36e225814aa3adc7754fdeb5930a2a86f34f AS deno

FROM --platform=$TARGETPLATFORM gcr.io/distroless/static-debian13:nonroot@sha256:25ac8f0c3b2334a9eb05452266bd4697864a8c8ef0ef71e5e6480d7f92868329

COPY --from=deno \
  /bin/deno /usr/local/bin/deno

ENTRYPOINT ["/usr/local/bin/deno"]
CMD ["-V"]
