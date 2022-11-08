#!/usr/bin/env bash
[ -z "$DEBUG" ] || set -x
set -eo pipefail

# Replaces Tekton's git-init which lacks retries: https://github.com/tektoncd/pipeline/issues/3515

# typical use:
    # args:
    # - -url
    # - $(params.giturl)
    # - -revision
    # - $(params.revision)
    # - -path
    # - /workspace/source
    # - -submodules=false
    # - -depth=1

[ $# != 8 ] && echo "Expected 8 args, got $# for $0: $@" && exit 1
[ "$1" != "-url" ] && echo "First arg should be -url, was $1" && exit 1
[ "$3" != "-revision" ] && echo "Third arg should be -revision, was $3" && exit 1
[ "$5" != "-path" ] && echo "Fifth arg should be -path, was $5" && exit 1
[ "$7" != "-submodules=false" ] && echo "Seventh arg should be -submodules=false, was $7" && exit 1
[ "$8" != "-depth=1" ] && echo "Eighth arg should be -depth=1, was $8" && exit 1

URL="$2"
[ -z "$URL" ] && echo "Second arg should be URL" && exit 1

REVISION="$4"
[ -z "$REVISION" ] && echo "Fourth arg should be revision" && exit 1

CLONEPATH="$6"
[ -z "$CLONEPATH" ] && echo "Sixth arg should be clonepath" && exit 1

retries=3

until git clone --depth 1 --branch "$REVISION" "$URL" $CLONEPATH; do
  [ $retries -gt 0 ] || exit 1
  retries=$(( $retries - 1 ))
  wait=$((10 + $RANDOM % 20))
  echo "Git failed, retrying in ${wait}s"
  sleep $wait
done
