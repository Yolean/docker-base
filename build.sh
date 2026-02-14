#!/usr/bin/env bash
[ -z "$DEBUG" ] || set -x
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
source "$SCRIPT_DIR/images.sh"

[ -n "$TAG" ] || TAG="latest"

usage() {
  echo "Usage: $0 [--all] [image ...]"
  echo
  echo "Build images locally (host arch only) with dependency resolution."
  echo
  echo "Examples:"
  echo "  $0 node-kafka              # builds node + node-kafka (with deps)"
  echo "  $0 duckdb headless-chrome  # builds multiple targets"
  echo "  $0 --all                   # builds everything"
  exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

REQUESTED=""
if [ "$1" = "--all" ]; then
  REQUESTED="$MULTIARCH_NONROOT $MULTIARCH_TONONROOT"
else
  REQUESTED="$@"
fi

# Check that all requested images exist
for IMG in $REQUESTED; do
  if [ ! -d "$IMG" ]; then
    echo "Error: no directory $IMG/ found" >&2
    exit 1
  fi
done

# Resolve build order (includes transitive deps)
BUILD_ORDER=$(resolve_build_order $REQUESTED)

echo "Build order:"
for IMG in $BUILD_ORDER; do
  echo "  $IMG"
done
echo

# Generate nonroot Dockerfiles
generate_nonroot_dockerfiles

is_tononroot() {
  local IMG=$1
  for T in $MULTIARCH_TONONROOT; do
    [ "$T" = "$IMG" ] && return 0
  done
  return 1
}

build_image() {
  local CONTEXT=$1
  local NAME=$2
  local IMG_TAG=$3

  local DEPENDENCIES
  DEPENDENCIES=$(get_yolean_deps "$CONTEXT/Dockerfile")

  local BUILD_CONTEXT_ARGS=""
  for DEP_FULL in $DEPENDENCIES; do
    BUILD_CONTEXT_ARGS="$BUILD_CONTEXT_ARGS --build-context $DEP_FULL=docker-image://yolean/$DEP_FULL"
  done

  echo "==> Building yolean/$NAME:$IMG_TAG from $CONTEXT/"
  docker buildx build \
    --load \
    $BUILD_CONTEXT_ARGS \
    --tag "yolean/$NAME:$IMG_TAG" \
    "$CONTEXT"
}

for IMG in $BUILD_ORDER; do
  if is_tononroot "$IMG"; then
    build_image "$IMG" "$IMG" root
    build_image "to-nonroot/$IMG" "$IMG" latest
  else
    build_image "$IMG" "$IMG" latest
  fi
done

echo
echo "Done. Built images:"
for IMG in $BUILD_ORDER; do
  if is_tononroot "$IMG"; then
    echo "  yolean/$IMG:root"
    echo "  yolean/$IMG:latest"
  else
    echo "  yolean/$IMG:latest"
  fi
done
