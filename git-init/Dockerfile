FROM gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.23.0@sha256:2ea2ea78928b365d6d13c5308f9fff63f685063684c843611be74abc43ea4f1c

RUN echo 'nonroot:x:65532:65534:nobody:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot

USER nonroot:nobody
