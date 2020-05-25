# docker-base

https://hub.docker.com/r/yolean/

Note that `Dockerfile`s typically result in 'USER root`
but that [autobuilds](./hooks/build) append a [nonroot](./nonroot-footer.Dockerfile) step.

Autobuilds are at https://hub.docker.com/r/solsson/y-docker-base but manually retagged/promoted using
`YOLEAN_PROMOTE=true IMAGE_NAME=solsson/y-docker-base:latest ./hooks/build`.
The resulting images are `yolean/<name>:<ref>` and `yolean/<name>:<ref>-root`.
Not all builds are promoted, and unfortunately [tags pages](https://hub.docker.com/r/yolean/node-kafka/tags) fail to list the pushed images that are identical to the autobuild
(i.e. all of them) but tags can be listed using for exampe `docker run --rm gcr.io/go-containerregistry/crane ls yolean/node-kafka`.
