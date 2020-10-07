FROM gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.17.0@sha256:e3b125e80654d33b4a3d2a29d8a9b0d155185dcddad91ade0ac7b85c71b43c95

RUN echo 'nonroot:x:65532:65534:nobody:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot

USER nonroot:nobody
