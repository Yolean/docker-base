FROM --platform=$TARGETPLATFORM denoland/deno:distroless-2.1.1@sha256:8c7fbba4e216e9535ac9869744ce36e225814aa3adc7754fdeb5930a2a86f34f AS deno

FROM --platform=$TARGETPLATFORM gcr.io/distroless/static-debian13:nonroot@sha256:e3f945647ffb95b5839c07038d64f9811adf17308b9121d8a2b87b6a22a80a39

COPY --from=deno \
  /bin/deno /usr/local/bin/deno

ENTRYPOINT ["/usr/local/bin/deno"]
CMD ["-V"]
