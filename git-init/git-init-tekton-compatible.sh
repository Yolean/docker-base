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

[ -d $CLONEPATH ] || mkdir -p $CLONEPATH

cd $CLONEPATH

# https://github.com/tektoncd/pipeline/blob/v0.41.0/pkg/git/git.go#L94
git config --add --global safe.directory $CLONEPATH

[ -d "$CLONEPATH/.git" ] && git remote -v && git remote set-url origin $URL || {
  git init
  git remote add origin $URL
}

# https://github.com/tektoncd/pipeline/blob/v0.41.0/pkg/git/git.go#L285
git config core.sparsecheckout true

retries=3
until git fetch --depth=1 origin --update-head-ok --force $REVISION; do
  [ $retries -gt 0 ] || exit 1
  retries=$(( $retries - 1 ))
  wait=$((10 + $RANDOM % 50))
  echo "Git failed, retrying in ${wait}s"
  sleep $wait
done

git rev-parse --verify "$REVISION^{commit}" 2>/dev/null \
  && git checkout -f $REVISION \
  || git checkout -f -B $REVISION origin/$REVISION
