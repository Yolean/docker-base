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

BEGIN="    ### build steps below are generated ###"
CURRENT=.github/workflows/images.yaml
ACTIONS=$(mktemp)
sed "/^$BEGIN\$/q" $CURRENT > $ACTIONS

function base_action {
  local CONTEXT=$1
  local NAME=$2
  local TAG=$3
  local TAGSUFFIX=""
  [ "$TAG" = "latest" ] || local TAGSUFFIX="-$TAG"
  cat <<EOF
    -
      name: Build and push $NAME $TAG
      uses: docker/build-push-action@v5
      env:
        SOURCE_DATE_EPOCH: 0
      with:
        context: $CONTEXT
        tags: |
          ghcr.io/yolean/$NAME:$TAG
          ghcr.io/yolean/$NAME:\${{ github.sha }}$TAGSUFFIX
        platforms: linux/amd64,linux/arm64/v8
        push: true
        cache-from: type=gha
        cache-to: type=gha,mode=max
EOF
}

function add_dependencies {
  local CONTEXT=$1
  local DEPENDENCIES="$((grep -e 'FROM --platform=$TARGETPLATFORM yolean/' $CONTEXT/Dockerfile || true) | cut -d' ' -f3)"
  [ -z "$DEPENDENCIES" ] || echo "        build-contexts: |"
  for NAME in $DEPENDENCIES; do
    echo "          $NAME=docker-image://ghcr.io/$NAME"
  done
}

for CONTEXT in $MULTIARCH_NONROOT; do
  base_action "$CONTEXT" "$CONTEXT" latest >> $ACTIONS
  add_dependencies "$CONTEXT" >> $ACTIONS
done

for CONTEXT in $MULTIARCH_TONONROOT; do
  mkdir -p to-nonroot/$CONTEXT
  echo "FROM --platform=\$TARGETPLATFORM yolean/$CONTEXT:root" > to-nonroot/$CONTEXT/Dockerfile
  cat nonroot-footer.Dockerfile >> to-nonroot/$CONTEXT/Dockerfile
  base_action "$CONTEXT" "$CONTEXT" root >> $ACTIONS
  add_dependencies "$CONTEXT" >> $ACTIONS
  base_action "to-nonroot/$CONTEXT" "$CONTEXT" latest >> $ACTIONS
  add_dependencies "to-nonroot/$CONTEXT" >> $ACTIONS
done

for CONTEXT in $AMD64ONLY; do
  echo "# TODO does $CONTEXT really need to be amd64-only?" >&2
done

cp $ACTIONS $CURRENT
GIT_STATUS=$(git status --untracked-files=no --porcelain=v2)
[ -z "$GIT_STATUS" ] && echo "Done, no local diff" || echo "Done, with local diff"
