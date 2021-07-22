FROM gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.26.0@sha256:8a5ed01f5a0684a90a2f42d247a10a2274f974759562329b200abaed4a804508

RUN echo 'nonroot:x:65532:65534:nobody:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot

USER nonroot:nobody
