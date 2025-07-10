#!/usr/bin/env bash
[ -z "$DEBUG" ] || set -x
set -eo pipefail

DEFAULT_PLATFORMS="linux/amd64,linux/arm64/v8"

# Define all images with their properties
# Structure: name;context;platforms;tag_suffix;dependencies_raw
# dependencies_raw is a space-separated list of direct yolean parent images found in Dockerfile

# Helper function to extract direct yolean dependencies from a Dockerfile
get_raw_deps() {
  local dockerfile_path=$1
  if [ -f "$dockerfile_path" ]; then
    # Adjusted grep to handle various FROM formats more reliably for yolean dependencies
    # It captures the full 'yolean/image:tag' or 'yolean/image'
    grep -Eo --no-filename 'yolean/([^ ]+)' "$dockerfile_path" | sort -u | tr '\n' ' ' | sed 's/ $//'
  else
    echo ""
  fi
}

IMAGES_DATA=()

# Base images / No internal yolean dependencies from Dockerfile
IMAGES_DATA+=( "docker-base;docker-base;$DEFAULT_PLATFORMS;;" )
IMAGES_DATA+=( "builder-base;builder-base;$DEFAULT_PLATFORMS;;" )
IMAGES_DATA+=( "builder-node;builder-node;$DEFAULT_PLATFORMS;;" )
IMAGES_DATA+=( "node-distroless;node-distroless;$DEFAULT_PLATFORMS;;" )
IMAGES_DATA+=( "git-http-readonly;git-http-readonly;$DEFAULT_PLATFORMS;;" )
IMAGES_DATA+=( "runtime-quarkus;runtime-quarkus;$DEFAULT_PLATFORMS;;" )
IMAGES_DATA+=( "runtime-deno;runtime-deno;$DEFAULT_PLATFORMS;;" )


# Images with known dependencies
RAW_DEPS=$(get_raw_deps builder-base-gcc/Dockerfile)
IMAGES_DATA+=( "builder-base-gcc;builder-base-gcc;$DEFAULT_PLATFORMS;;$RAW_DEPS" )

RAW_DEPS=$(get_raw_deps builder-base-gcloud/Dockerfile)
IMAGES_DATA+=( "builder-base-gcloud;builder-base-gcloud;$DEFAULT_PLATFORMS;;$RAW_DEPS" )

RAW_DEPS=$(get_raw_deps builder-tooling/Dockerfile)
IMAGES_DATA+=( "builder-tooling;builder-tooling;$DEFAULT_PLATFORMS;;$RAW_DEPS" )

RAW_DEPS=$(get_raw_deps builder-quarkus/Dockerfile)
IMAGES_DATA+=( "builder-quarkus;builder-quarkus;$DEFAULT_PLATFORMS;;$RAW_DEPS" )

RAW_DEPS=$(get_raw_deps builder-evidence/Dockerfile)
IMAGES_DATA+=( "builder-evidence;builder-evidence;$DEFAULT_PLATFORMS;;$RAW_DEPS" )

RAW_DEPS=$(get_raw_deps git-init/Dockerfile)
IMAGES_DATA+=( "git-init;git-init;$DEFAULT_PLATFORMS;;$RAW_DEPS" )

RAW_DEPS=$(get_raw_deps toil/Dockerfile)
IMAGES_DATA+=( "toil;toil;$DEFAULT_PLATFORMS;;$RAW_DEPS" )

RAW_DEPS=$(get_raw_deps toil-network/Dockerfile)
IMAGES_DATA+=( "toil-network;toil-network;$DEFAULT_PLATFORMS;;$RAW_DEPS" )

RAW_DEPS=$(get_raw_deps headless-chrome/Dockerfile)
IMAGES_DATA+=( "headless-chrome;headless-chrome;linux/amd64;;$RAW_DEPS" )

# To-nonroot images: each generates a :root image and a :latest image
MULTIARCH_TONONROOT_LIST=(
  "homedir"
  "java"
  "node"
  "node-kafka"
  "node-kafka-cache"
  "node-kafka-sqlite"
  "node-kafka-duckdb"
  "node-watchexec"
  "node-kafka-watch"
  "node-gcloud"
  "node-vitest"
  "runtime-quarkus-ubuntu"
  "runtime-quarkus-deno"
  "runtime-quarkus-ubuntu-jre"
  "runtime-quarkus-dev"
  "toil-storage"
  "curl-yq"
  "duckdb"
)

for CONTEXT_NAME in "${MULTIARCH_TONONROOT_LIST[@]}"; do
  # :root image
  RAW_DEPS_ROOT=$(get_raw_deps $CONTEXT_NAME/Dockerfile)
  IMAGES_DATA+=( "$CONTEXT_NAME;$CONTEXT_NAME;$DEFAULT_PLATFORMS;-root;$RAW_DEPS_ROOT" )

  # :latest image (depends on the :root version of itself)
  # Ensure the to-nonroot directory exists
  mkdir -p "to-nonroot/$CONTEXT_NAME"
  # Create the Dockerfile for the non-root version
  echo "FROM --platform=\$TARGETPLATFORM yolean/$CONTEXT_NAME:root" > "to-nonroot/$CONTEXT_NAME/Dockerfile"
  if [ -f nonroot-footer.Dockerfile ]; then
    cat nonroot-footer.Dockerfile >> "to-nonroot/$CONTEXT_NAME/Dockerfile"
  else
    echo "# nonroot-footer.Dockerfile not found, ensure it exists or adjust script" >> "to-nonroot/$CONTEXT_NAME/Dockerfile"
  fi
  
  IMAGES_DATA+=( "$CONTEXT_NAME;to-nonroot/$CONTEXT_NAME;$DEFAULT_PLATFORMS;;yolean/$CONTEXT_NAME:root" )
done


BEGIN_MARKER="    ### build steps below are generated ###"
END_MARKER="    ### end of generated build steps ###"
CURRENT_WORKFLOW_FILE=".github/workflows/images.yaml"
NEW_WORKFLOW_CONTENT_TEMP=$(mktemp)

# Check if workflow file exists before trying to read from it
if [ ! -f "$CURRENT_WORKFLOW_FILE" ]; then
    echo "Workflow file $CURRENT_WORKFLOW_FILE does not exist. Creating a new one."
    # Add minimal structure if creating new
    cat <<EOF > "$NEW_WORKFLOW_CONTENT_TEMP"
name: images

on:
  push:
    branches:
    - main

jobs:
  publish:
    name: Publish
    runs-on: ubuntu-latest
    permissions:
      packages: write
      contents: read # For actions/cache
$BEGIN_MARKER
EOF
else
    sed "/^$BEGIN_MARKER\$/q" "$CURRENT_WORKFLOW_FILE" > "$NEW_WORKFLOW_CONTENT_TEMP"
fi


cat <<EOF >> "$NEW_WORKFLOW_CONTENT_TEMP"
    strategy:
      fail-fast: false
      matrix:
        image:
EOF

for item in "${IMAGES_DATA[@]}"; do
  IFS=';' read -r name context platforms tag_suffix deps_raw <<< "$item"
  current_platforms=${platforms:-$DEFAULT_PLATFORMS}

  cat <<EOF >> "$NEW_WORKFLOW_CONTENT_TEMP"
          - name: "$name" 
            context: "$context"
            platforms: "$current_platforms"
EOF
  if [ -n "$tag_suffix" ]; then
    cat <<EOF >> "$NEW_WORKFLOW_CONTENT_TEMP"
            tag_suffix: "$tag_suffix"
EOF
  fi

  if [ -n "$deps_raw" ]; then
    echo "            dependencies: |" >> "$NEW_WORKFLOW_CONTENT_TEMP"
    for dep_entry in $deps_raw; do
      # dep_entry is like "yolean/parent-image" or "yolean/parent-image:some-tag"
      dep_repo_and_name=$(echo "$dep_entry" | sed -E 's/^yolean\///' | cut -d':' -f1) 
      original_dep_tag=$(echo "$dep_entry" | grep -q ':' && echo "$dep_entry" | cut -d':' -f2 || echo "") 
      
      sha_tag_suffix=""
      if [ -n "$original_dep_tag" ]; then
        # This suffix is for the SHA tag, e.g., SHA-root
        sha_tag_suffix="-$original_dep_tag" 
      fi
      
      # The key for build-contexts is the original FROM line value e.g. yolean/parent:tag
      # The value points to the image built in this run, tagged with SHA and its specific suffix.
      echo "              $dep_entry=docker-image://ghcr.io/yolean/$dep_repo_and_name:\${{ github.sha }}$sha_tag_suffix" >> "$NEW_WORKFLOW_CONTENT_TEMP"
    done
  fi
done

cat <<EOF >> "$NEW_WORKFLOW_CONTENT_TEMP"
    steps:
    -
      name: Checkout
      uses: actions/checkout@v4
    -
      name: Login to GitHub Container Registry
      uses: docker/login-action@v3
      with:
        registry: ghcr.io
        username: \${{ github.repository_owner }}
        password: \${{ secrets.GITHUB_TOKEN }}
    -
      uses: actions/setup-go@v5
      with:
        go-version: "1.22"
    -
      uses: imjasonh/setup-crane@v0.3
    -
      name: Crane copy external images
      if: \${{ strategy.job-index == 0 }} # Run only for the first job in the matrix to avoid duplication
      run: |
        set -x
        TAG_KKV=7fa31f42731fc20a77988b478a3896732cc3dc88
        TAG_HOOK=92363d7d1771abc780e7559c778215be61f934d4
        TAG_KAFKA=2.5.1-kafka-server-start
        TAG_ZOOKEEPER=2.5.1-zookeeper-server-start
        TAG_INITUTILS=initutils-nonroot@sha256:8988aca5b34feabe8d7d4e368f74b2ede398f692c7e99a38b262a938d475812c
        TAG_ENVOY=v1.34.1
        TAG_CURL=8.9.1
        TAG_BUSYBOX=1.36.1-glibc
        TAG_TINYGO=0.32.0
        TAG_KAFKACAT=1.7.0@sha256:8658c1fa53632764bfcc3f9fad3dbf8b1d1a74f05244cd3a0ce9825e3344dc98
        crane cp docker.io/yolean/kafka-keyvalue:\$TAG_KKV ghcr.io/yolean/kafka-keyvalue:\$TAG_KKV
        crane digest docker.io/yolean/kafka-hook:\$TAG_HOOK
        crane cp docker.io/yolean/kafka-hook:\$TAG_HOOK ghcr.io/yolean/kafka-hook:\$TAG_HOOK
        crane cp solsson/kafka:\$TAG_KAFKA ghcr.io/yolean/kafka:\$TAG_KAFKA
        crane cp solsson/kafka:\$TAG_ZOOKEEPER ghcr.io/yolean/kafka:\$TAG_ZOOKEEPER
        crane cp solsson/kafka:\$TAG_INITUTILS ghcr.io/yolean/kafka:\$TAG_INITUTILS
        crane cp solsson/minio-deduplication@sha256:af91c49ce795eb8406c6303d41fd874e231459bd8a5897a35bb12e1cc8f762a6 ghcr.io/yolean/minio-deduplication
        crane cp envoyproxy/envoy:v1.17.0 ghcr.io/yolean/envoy:v1.17.0
        crane cp envoyproxy/envoy:\$TAG_ENVOY ghcr.io/yolean/envoy:\$TAG_ENVOY
        crane cp envoyproxy/envoy-distroless:\$TAG_ENVOY ghcr.io/yolean/envoy-distroless:\$TAG_ENVOY
        crane cp curlimages/curl:\$TAG_CURL ghcr.io/yolean/curl:\$TAG_CURL
        crane cp busybox:\$TAG_BUSYBOX ghcr.io/yolean/busybox:\$TAG_BUSYBOX
        crane cp mailgun/kafka-pixy:0.17.0@sha256:0b5f4795c0b0d80729fa7415ec70ae4d411e152c6149656dddf01b18184792e0 ghcr.io/yolean/kafka-pixy:0.17.0
        crane cp tinygo/tinygo:\$TAG_TINYGO ghcr.io/yolean/tinygo:\$TAG_TINYGO
        crane cp liftm/kafkacat:\$TAG_KAFKACAT ghcr.io/yolean/kafkacat:\$TAG_KAFKACAT
    -
      name: Set up QEMU
      uses: docker/setup-qemu-action@v3
    -
      name: Set up Docker Buildx
      id: buildx
      uses: docker/setup-buildx-action@v3
    -
      name: Docker meta for \${{ matrix.image.name }}\${{ matrix.image.tag_suffix }}
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ghcr.io/\${{ github.repository_owner }}/\${{ matrix.image.name }} # Image name in GHCR is matrix.image.name
        tags: |
          type=sha,suffix=\${{ matrix.image.tag_suffix }} 
          type=raw,value=latest\${{ matrix.image.tag_suffix }},enable=\${{ github.ref == 'refs/heads/main' }}
    -
      name: Restore cache for \${{ matrix.image.name }}\${{ matrix.image.tag_suffix }}
      id: cache-restore
      uses: actions/cache/restore@v4
      with:
        path: /tmp/.buildx-cache-\${{ matrix.image.name }}\${{ matrix.image.tag_suffix }}
        key: buildx-cache-\${{ matrix.image.name }}\${{ matrix.image.tag_suffix }}-\${{ github.ref }}-\${{ github.sha }}
        restore-keys: |
          buildx-cache-\${{ matrix.image.name }}\${{ matrix.image.tag_suffix }}-\${{ github.ref }}-
          buildx-cache-\${{ matrix.image.name }}\${{ matrix.image.tag_suffix }}-refs/heads/main-
          buildx-cache-\${{ matrix.image.name }}\${{ matrix.image.tag_suffix }}-
    -
      name: Build and push \${{ matrix.image.name }}\${{ matrix.image.tag_suffix }}
      id: build-push
      uses: docker/build-push-action@v5
      env:
        SOURCE_DATE_EPOCH: 0
      with:
        builder: \${{ steps.buildx.outputs.name }}
        context: \${{ matrix.image.context }}
        file: ./\${{ matrix.image.context }}/Dockerfile
        platforms: \${{ matrix.image.platforms }}
        tags: \${{ steps.meta.outputs.tags }}
        labels: \${{ steps.meta.outputs.labels }}
        push: \${{ github.event_name != 'pull_request' }}
        build-contexts: |\${{ matrix.image.dependencies }} 
        cache-from: type=local,src=/tmp/.buildx-cache-\${{ matrix.image.name }}\${{ matrix.image.tag_suffix }}
        outputs: type=local,dest=/tmp/.buildx-cache-new-\${{ matrix.image.name }}\${{ matrix.image.tag_suffix }}
    -
      name: Save cache for \${{ matrix.image.name }}\${{ matrix.image.tag_suffix }}
      uses: actions/cache/save@v4
      if: always()
      with:
        path: /tmp/.buildx-cache-new-\${{ matrix.image.name }}\${{ matrix.image.tag_suffix }} # Save the new cache dir
        key: \${{ steps.cache-restore.outputs.cache-primary-key || format('buildx-cache-{0}{1}-{2}-{3}', matrix.image.name, matrix.image.tag_suffix, github.ref, github.sha) }} # Use restored key or new one

EOF

echo "$END_MARKER" >> "$NEW_WORKFLOW_CONTENT_TEMP"
cp "$NEW_WORKFLOW_CONTENT_TEMP" "$CURRENT_WORKFLOW_FILE"
rm "$NEW_WORKFLOW_CONTENT_TEMP"

echo "Done. Workflow file $CURRENT_WORKFLOW_FILE regenerated by new test.sh"
# Make the script executable
chmod +x test.sh

echo "To regenerate the workflow, run: ./test.sh"

GIT_STATUS=$(git status --porcelain=v2 "$CURRENT_WORKFLOW_FILE" "test.sh" || true)
[ -z "$GIT_STATUS" ] && echo "No local diffs." || echo "Local diffs detected."
