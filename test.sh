#!/usr/bin/env bash
[ -z "$DEBUG" ] || set -x
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/images.sh"

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

  # Get dependencies for build-contexts
  local DEPENDENCIES="$(get_yolean_deps "$CONTEXT/Dockerfile")"

  # Determine platforms (override if in SINGLE_ARCH_AMD64)
  local PLATFORMS="linux/amd64,linux/arm64/v8"
  for ONLY_AMD64 in $SINGLE_ARCH_AMD64; do
    if [ "$NAME" = "$ONLY_AMD64" ]; then
      PLATFORMS="linux/amd64"
      break
    fi
  done

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
        platforms: $PLATFORMS
        push: true
        cache-from: type=registry,ref=ghcr.io/yolean/$NAME:_buildcache$TAGSUFFIX
        cache-to: type=registry,ref=ghcr.io/yolean/$NAME:_buildcache$TAGSUFFIX,mode=max
EOF

  # Add build-contexts if there are dependencies
  if [ ! -z "$DEPENDENCIES" ]; then
    echo "        build-contexts: |"
    for NAME_FULL in $DEPENDENCIES; do
      echo "          $NAME_FULL=docker-image://ghcr.io/$NAME_FULL"
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

generate_nonroot_dockerfiles

for CONTEXT in $MULTIARCH_TONONROOT; do
  base_action "$CONTEXT" "$CONTEXT" root >> $ACTIONS
  base_action "to-nonroot/$CONTEXT" "$CONTEXT" latest >> $ACTIONS
done

cp $ACTIONS $CURRENT
GIT_STATUS=$(git status --untracked-files=no --porcelain=v2)
[ -z "$GIT_STATUS" ] && echo "Done, no local diff" || echo "Done, with local diff"
