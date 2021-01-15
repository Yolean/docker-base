FROM gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.20.0@sha256:6b6a8fd4a7aeae8995a4acd2b2fb77458c287b309f2ccabdb257a067f37521b8

RUN echo 'nonroot:x:65532:65534:nobody:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot

USER nonroot:nobody
