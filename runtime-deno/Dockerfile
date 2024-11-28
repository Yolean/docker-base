FROM denoland/deno:distroless-2.1.1@sha256:8c7fbba4e216e9535ac9869744ce36e225814aa3adc7754fdeb5930a2a86f34f AS deno

FROM --platform=$TARGETPLATFORM gcr.io/distroless/static-debian12:nonroot@sha256:d71f4b239be2d412017b798a0a401c44c3049a3ca454838473a4c32ed076bfea

COPY --from=deno \
  /bin/deno /usr/local/bin/deno

ENTRYPOINT ["/usr/local/bin/deno"]
CMD ["-V"]
