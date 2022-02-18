# docker-base

https://hub.docker.com/r/yolean/

Note that `Dockerfile`s typically result in 'USER root`
but that [autobuilds](./hooks/build) append a [nonroot](./nonroot-footer.Dockerfile) step.

Autobuilds are at https://hub.docker.com/r/solsson/y-docker-base
but push with git ref tags to https://hub.docker.com/r/yolean/<name>.

## build locally

```
# Nopush is broken for multi-arch builds until we find a way to depend on local builds
# NOPUSH=true ./hooks/build
REGISTRY=docker.io ./hooks/build
```
