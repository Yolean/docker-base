FROM gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.19.0@sha256:db3e7431b11917f21c6978f478298dcb5b2b4048e9f1ec5c0246d72b66c820c7

RUN echo 'nonroot:x:65532:65534:nobody:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot

USER nonroot:nobody
