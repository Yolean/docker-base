#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<EOF
Usage: $0 <image[:tag]> [--raw] [--debug]
  --raw     Print full attestation JSON (can repeat for multiple)
  --debug   Show crane commands executed
Defaults to :latest if no tag provided.
EOF
}

if ! command -v crane >/dev/null 2>&1; then
  echo "crane not found in PATH" >&2; exit 1; fi
if ! command -v jq >/dev/null 2>&1; then
  echo "jq not found in PATH" >&2; exit 1; fi

[ $# -ge 1 ] || { usage; exit 1; }

IMAGE="$1"; shift || true
RAW="false"; DEBUG="false"
while [ $# -gt 0 ]; do
  case "$1" in
    --raw) RAW="true";;
    --debug) DEBUG="true";;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1;;
  esac
  shift
done

# Add :latest if no explicit tag or digest
if [[ "$IMAGE" != *:@* && "$IMAGE" != *:*/*:* && "$IMAGE" != *:*:* && "$IMAGE" != *@sha256:* ]]; then
  # has no :tag part after last slash
  if [[ "$IMAGE" != *:* ]]; then
    IMAGE+=":latest"
  fi
fi

echo "Inspecting provenance for $IMAGE" >&2

# Obtain manifest list (or single manifest) JSON
if ! MANIFEST_JSON=$(crane manifest "$IMAGE" 2>/dev/null); then
  echo "Failed to fetch manifest for $IMAGE" >&2; exit 1;
fi

# If it's a single-platform manifest, wrap to unify processing
if ! echo "$MANIFEST_JSON" | jq -e '.manifests' >/dev/null 2>&1; then
  MANIFEST_LIST_JSON='{"manifests":[]}'
else
  MANIFEST_LIST_JSON="$MANIFEST_JSON"
fi

UNKNOWN_DIGESTS=$(echo "$MANIFEST_LIST_JSON" | jq -r '.manifests[]? | select(.platform.os=="unknown" and .platform.architecture=="unknown") | .digest')
if [ -z "$UNKNOWN_DIGESTS" ]; then
  echo "No unknown/unknown platform manifests (attestations) found." >&2
  echo "Hint: ensure builds set provenance and sbom (buildkit) or attest step." >&2
  exit 2
fi

FOUND=0
REGISTRY="${IMAGE%%/*}" # crude but ok for ghcr.io/owner/name:tag
REPO_TAG=${IMAGE#*/}
# Split repo and tag/digest
if [[ "$REPO_TAG" == *"@sha256:"* ]]; then
  REPO="${REPO_TAG%@sha256:*}"; REF="${REPO_TAG#*@}"; REF_TYPE=digest
else
  REPO="${REPO_TAG%%:*}"; REF="${REPO_TAG##*:}"; REF_TYPE=tag
fi

IMAGE_PATH=${IMAGE#*/}            # remove registry
REPO_PATH=${IMAGE_PATH%%@*}       # drop @digest if any
REPO_PATH=${REPO_PATH%%:*}        # drop :tag

[ "$DEBUG" = "true" ] && echo "+ crane manifest $IMAGE # top-level" >&2

for DGST in $UNKNOWN_DIGESTS; do
  BASE_REF=${IMAGE%%@*}; BASE_REF=${BASE_REF%%:*} # registry/owner/name
  SUB_JSON=$(crane manifest "${BASE_REF}@${DGST}" 2>/dev/null) || continue
  [ "$DEBUG" = "true" ] && echo "+ crane manifest ${BASE_REF}@${DGST}" >&2
  LAYER_DIGESTS=$(echo "$SUB_JSON" | jq -r '.layers[]? | select(.mediaType | test("in-toto")) | .digest')
  [ -z "$LAYER_DIGESTS" ] && continue
  for LD in $LAYER_DIGESTS; do
    FOUND=1
    [ "$DEBUG" = "true" ] && echo "Sub-manifest digest: $DGST" >&2 && echo "In-toto layer digest: $LD" >&2
    # Retrieve attestation layer (handle crane versions expecting single arg)
    [ "$DEBUG" = "true" ] && echo "+ crane blob ${BASE_REF}@${LD}" >&2
    ATTESTATION=$(crane blob "${BASE_REF}@${LD}" 2>/dev/null || crane blob "${IMAGE%@*}@${LD}" 2>/dev/null || true)
    [ -z "$ATTESTATION" ] && continue
    if [ "$RAW" = "true" ]; then
      echo "$ATTESTATION" | jq '.'
      continue
    fi
    echo "--- Attestation layer $LD (sub-manifest $DGST) ---"
    JQ_SUMMARY='def dockerfiles: [ (.. | objects | to_entries[]? | select(.key|test("dockerfile";"i")) | .value) ] | flatten | map(tostring) | unique | .;
      def mats: (.materials // .predicate.materials // []);
      def norm(u; d):
        if (u|startswith("docker-image://")) then
          (u | sub("^docker-image://";"")) as $ref |
          if (d|length>0) and ($ref|test("@sha256:" )|not) then ($ref|split("@")|.[0]) + "@sha256:" + d else $ref end
        elif (u|startswith("pkg:docker/")) then
          (u | sub("^pkg:docker/";"") | split("?") | .[0]) as $ref |
          if (d|length>0) and ($ref|test("@sha256:" )|not) then ($ref|split("@")|.[0]) + "@sha256:" + d else $ref end
        else
          if (d|length>0) and (u|test("@sha256:" )|not) then (u + "@sha256:" + d) else u end
        end;
      def base_images: mats | map( ( .uri // .uri_ // empty ) as $u | ( .digest.sha256? // "" ) as $d | select($u != "") | norm($u; $d) ) | unique;
      def bkmeta: .predicate.metadata["https://mobyproject.org/buildkit@v1#metadata"].vcs? // {};
      def guess_source: (bkmeta.source // .predicate.invocation.environment.GIT_URL? // .predicate.buildConfig.sourceProvenance.resolvedRepoSource.repoUrl? // empty);
      def guess_revision: (bkmeta.revision // .predicate.invocation.environment.GITHUB_SHA? // .predicate.invocation.environment.GIT_COMMIT_SHA? // empty);
      ["Dockerfiles:"] + (dockerfiles| if length==0 then ["(none found)"] else . end) +
      ["Base images (materials):"] + (base_images | if length==0 then ["(none found)"] else . end) +
      ["VCS source:", (guess_source // "(unknown)"),
       "VCS revision:", (guess_revision // "(unknown)"),
       "Build started:", (.predicate.metadata.buildStartedOn? // "(unknown)"),
       "Build finished:", (.predicate.metadata.buildFinishedOn? // "(unknown)")] | .[]'
    [ "$DEBUG" = "true" ] && echo "+ jq -r <summary_program>" >&2 && echo "$JQ_SUMMARY" | sed 's/^/| /' >&2
    SUMMARY=$(echo "$ATTESTATION" | jq -r "$JQ_SUMMARY")
    if [ -z "${PREV_LAST:-}" ]; then
      echo "$SUMMARY"
    else
      DIFF_PRINTED=false
      while IFS= read -r line; do
        if ! printf '%s\n' "$PREV_LAST" | grep -Fxq "$line"; then
          [ "$DIFF_PRINTED" = false ] && echo "(diff from previous attestation)" && DIFF_PRINTED=true
          echo "$line"
        fi
      done <<< "$SUMMARY"
      [ "$DIFF_PRINTED" = false ] && echo "(no diff from previous attestation)"
    fi
    PREV_LAST="$SUMMARY"
  done
done

if [ $FOUND -eq 0 ]; then
  echo "No attestation (in-toto) layers found in unknown/unknown manifests." >&2
  exit 3
fi
