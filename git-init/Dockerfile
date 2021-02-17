FROM gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.21.0@sha256:db18a9c1607c8cbbcd72f61d0c4d795b9ff528669deacd5f8a1672e4ef198ffd

RUN echo 'nonroot:x:65532:65534:nobody:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot

USER nonroot:nobody
