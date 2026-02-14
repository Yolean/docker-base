#!/usr/bin/env bash
# images.sh — shared image lists and helper functions for test.sh and build.sh

# note that docker-base isn't actually nonroot, we just want to build that first
MULTIARCH_NONROOT="
docker-base
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
node-kafka-duckdb
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

# Images that are only buildable on amd64
SINGLE_ARCH_AMD64="headless-chrome"

# Generate nonroot Dockerfiles for TONONROOT images
generate_nonroot_dockerfiles() {
  for CONTEXT in $MULTIARCH_TONONROOT; do
    mkdir -p to-nonroot/$CONTEXT
    echo "FROM --platform=\$TARGETPLATFORM yolean/$CONTEXT:root" > to-nonroot/$CONTEXT/Dockerfile
    cat nonroot-footer.Dockerfile >> to-nonroot/$CONTEXT/Dockerfile
  done
}

# Get yolean/ dependencies from a Dockerfile's FROM lines
# Returns space-separated list of "yolean/name" or "yolean/name:tag" references
get_yolean_deps() {
  local DOCKERFILE=$1
  (grep -e 'FROM --platform=$TARGETPLATFORM yolean/' -e 'FROM --platform=$BUILDPLATFORM yolean/' "$DOCKERFILE" || true) | cut -d' ' -f3
}

# Resolve build order: given image names, return them plus all transitive
# dependencies in the order they appear in the master lists.
resolve_build_order() {
  local NEEDED=""

  _collect_deps() {
    local IMG=$1
    case " $NEEDED " in *" $IMG "*) return ;; esac
    NEEDED="$NEEDED $IMG"

    local DOCKERFILE="$IMG/Dockerfile"
    [ -f "$DOCKERFILE" ] || return 0

    local DEPS
    DEPS=$(get_yolean_deps "$DOCKERFILE")
    for DEP_FULL in $DEPS; do
      local DEP_NAME="${DEP_FULL#yolean/}"
      DEP_NAME="${DEP_NAME%%:*}"
      _collect_deps "$DEP_NAME"
    done
  }

  for IMG in "$@"; do
    _collect_deps "$IMG"
  done

  local ALL_IMAGES="$MULTIARCH_NONROOT $MULTIARCH_TONONROOT"
  for IMG in $ALL_IMAGES; do
    case " $NEEDED " in *" $IMG "*) echo "$IMG" ;; esac
  done
}
