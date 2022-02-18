FROM gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.32.1@sha256:02ffc8b09e575d1ee8cfcc5a82263cea56f3f5fe04ea1082bb06d98b5b83d5e4

RUN echo 'nonroot:x:65532:65534:nobody:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot

USER nonroot:nobody
