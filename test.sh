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

# note that docker-base isn't actually nonroot, we just want to build that first
MULTIARCH_NONROOT="
docker-base
builder-base
builder-base-gcc
builder-base-gcloud
builder-tooling
builder-node
builder-quarkus
builder-evidence
git-init
toil
toil-network
node-distroless
headless-chrome
git-http-readonly
runtime-quarkus
runtime-deno
"

MULTIARCH_TONONROOT="
homedir
java
node
node-kafka
node-kafka-cache
node-kafka-sqlite
node-watchexec
node-kafka-watch
node-gcloud
node-vitest
runtime-quarkus-ubuntu
runtime-quarkus-deno
runtime-quarkus-ubuntu-jre
runtime-quarkus-dev
toil-storage
curl-yq
duckdb
"

DEPRECATED="
runtime-quarkus-deno
runtime-deno
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
  # Create cache key that includes context for better cache scoping
  local CACHE_KEY_PREFIX="buildx-$NAME-$TAG"
  
  # Get dependencies for build-contexts
  local DEPENDENCIES="$((grep -e 'FROM --platform=$TARGETPLATFORM yolean/' -e 'FROM --platform=$BUILDPLATFORM yolean/' $CONTEXT/Dockerfile || true) | cut -d' ' -f3)"
  
  cat <<EOF
    -
      name: Build and push $NAME $TAG
      uses: docker/build-push-action@v6.18.0
      env:
        SOURCE_DATE_EPOCH: 0
        BUILDKIT_PROGRESS: plain
        DOCKER_BUILDKIT: 1
      with:
        context: $CONTEXT
        tags: |
          ghcr.io/yolean/$NAME:$TAG
          ghcr.io/yolean/$NAME:\${{ github.sha }}$TAGSUFFIX
        platforms: linux/amd64,linux/arm64/v8
        push: true
        cache-from: |
          type=gha,scope=$CACHE_KEY_PREFIX
          type=gha,scope=buildx-$NAME
        cache-to: type=gha,mode=max,scope=$CACHE_KEY_PREFIX
EOF
  
  # Add build-contexts if there are dependencies
  if [ ! -z "$DEPENDENCIES" ]; then
    echo "        build-contexts: |"
    for NAME_FULL in $DEPENDENCIES; do
      # Extract image name without tag
      local IMAGE_NAME=$(echo "$NAME_FULL" | cut -d':' -f1)
      echo "          $IMAGE_NAME=docker-image://ghcr.io/$NAME_FULL"
    done
  fi
  
  cat <<EOF
      continue-on-error: false
      timeout-minutes: 45
EOF
}



for CONTEXT in $MULTIARCH_NONROOT; do
  base_action "$CONTEXT" "$CONTEXT" latest >> $ACTIONS
done

for CONTEXT in $MULTIARCH_TONONROOT; do
  mkdir -p to-nonroot/$CONTEXT
  echo "FROM --platform=\$TARGETPLATFORM yolean/$CONTEXT:root" > to-nonroot/$CONTEXT/Dockerfile
  cat nonroot-footer.Dockerfile >> to-nonroot/$CONTEXT/Dockerfile
  base_action "$CONTEXT" "$CONTEXT" root >> $ACTIONS
  base_action "to-nonroot/$CONTEXT" "$CONTEXT" latest >> $ACTIONS
done

cp $ACTIONS $CURRENT
GIT_STATUS=$(git status --untracked-files=no --porcelain=v2)
[ -z "$GIT_STATUS" ] && echo "Done, no local diff" || echo "Done, with local diff"
