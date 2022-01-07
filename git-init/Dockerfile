FROM gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.31.0@sha256:86fce1d4245b9d7318e31635e0a310df6a88fe1cfe5d9f37406dde746ac15e1a

RUN echo 'nonroot:x:65532:65534:nobody:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot

USER nonroot:nobody
