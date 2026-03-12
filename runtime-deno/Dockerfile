FROM --platform=$TARGETPLATFORM denoland/deno:distroless-2.1.1@sha256:8c7fbba4e216e9535ac9869744ce36e225814aa3adc7754fdeb5930a2a86f34f AS deno

FROM --platform=$TARGETPLATFORM gcr.io/distroless/static-debian13:nonroot@sha256:f512d819b8f109f2375e8b51d8cfd8aafe81034bc3e319740128b7d7f70d5036

COPY --from=deno \
  /bin/deno /usr/local/bin/deno

ENTRYPOINT ["/usr/local/bin/deno"]
CMD ["-V"]
