#!/usr/bin/env bash
[ -z "$DEBUG" ] || set -x
set -eo pipefail

[ -n "$PLATFORMS" ] || PLATFORMS="linux/amd64,linux/arm64/v8"
[ -n "$PLATFORM" ] || PLATFORM="--platform=$PLATFORMS"

[ -z "$REGISTRY" ] || PREFIX="$REGISTRY/"

SOURCE_COMMIT=$(git rev-parse --verify HEAD 2>/dev/null || echo '')
if [[ ! -z "$SOURCE_COMMIT" ]]; then
  GIT_STATUS=$(git status --untracked-files=normal --porcelain=v2 | grep -v ' hooks/build' || true)
  if [[ ! -z "$GIT_STATUS" ]]; then
    SOURCE_COMMIT="$SOURCE_COMMIT-dirty"
  fi
fi

MULTIARCH_NONROOT="
builder-base
builder-base-gcc
builder-base-gcloud
builder-tooling
builder-node
builder-quarkus
git-init
toil
toil-network
node-distroless
blobs
"

MULTIARCH_TONONROOT="
java
node
node-kafka
node-kafka-cache
node-watchexec
node-gcloud
runtime-quarkus-ubuntu
runtime-quarkus-ubuntu-jre
runtime-quarkus-dev
toil-storage
"

AMD64ONLY="
runtime-quarkus
runtime-quarkus-deno
runtime-deno
git-http-readonly
headless-chrome
"

for CONTEXT in $MULTIARCH_NONROOT; do
  echo "# MULTIARCH_NONROOT $CONTEXT"
done

for CONTEXT in $MULTIARCH_TONONROOT; do
  mkdir -p to-nonroot/$CONTEXT
  echo "FROM --platform=\$TARGETPLATFORM yolean/$CONTEXT:root" > to-nonroot/$CONTEXT/Dockerfile
  cat nonroot-footer.Dockerfile >> to-nonroot/$CONTEXT/Dockerfile
done

for CONTEXT in $AMD64ONLY; do
  echo "# AMD64ONLY $CONTEXT"
done
