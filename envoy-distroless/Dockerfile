FROM --platform=$TARGETPLATFORM envoyproxy/envoy:distroless-v1.37.1@sha256:4d9226b9fd4d1449887de7cde785beb24b12e47d6e79021dec3c79e362609432 AS envoy

FROM --platform=$TARGETPLATFORM gcr.io/distroless/base-debian13:nonroot@sha256:a696c7c8545ba9b2b2807ee60b8538d049622f0addd85aee8cec3ec1910de1f9

COPY --from=envoy /usr/local/bin/envoy /usr/local/bin/envoy
COPY --from=envoy /etc/envoy/ /etc/envoy/

ENTRYPOINT ["/usr/local/bin/envoy"]
CMD ["-c", "/etc/envoy/envoy.yaml"]
