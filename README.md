# docker-base

https://hub.docker.com/r/yolean/

Note that `Dockerfile`s typically result in 'USER root`
but that [autobuilds](./hooks/build) append a [nonroot](./nonroot-footer.Dockerfile) step.

Autobuilds are at https://hub.docker.com/r/solsson/y-docker-base but manually retagged/promoted using
`YOLEAN_PROMOTE=true IMAGE_NAME=solsson/y-docker-base:latest ./hooks/build`.
