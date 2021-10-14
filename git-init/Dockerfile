FROM gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.28.2@sha256:bf23fb1a386e9e287855895b7118c1432ff9051285314a0e815d0a172edcb5c3

RUN echo 'nonroot:x:65532:65534:nobody:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot

USER nonroot:nobody
