FROM gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.27.0@sha256:8bfb6edbd8ce4608af957a3a38444512c14713bc9fc0d60308f228c61be4c83f

RUN echo 'nonroot:x:65532:65534:nobody:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot

USER nonroot:nobody
