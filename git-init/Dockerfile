FROM gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.18.1@sha256:406e9a4f9d10dbc59e141c1584d1d4dcff995012071eb425a3c117ec0dfe16af

RUN echo 'nonroot:x:65532:65534:nobody:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot

USER nonroot:nobody
