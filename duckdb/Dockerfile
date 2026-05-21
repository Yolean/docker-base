# syntax=docker/dockerfile:1.7-labs
#
# DuckDB CLI compiled from source so we can statically link extensions that are
# not published as prebuilt binaries for the 1.5.x line — notably `tributary`
# (Kafka, community) — alongside `httpfs` (which provides https:// and Google
# Cloud Storage gs:// access; there are no separate `https`/`gcs` extensions).
#
# The build mirrors DuckDB's own community-extension CI: the manylinux + vcpkg
# toolchain from duckdb/extension-ci-tools, then `make release` against a pinned
# duckdb checkout. Because the toolchain matches the official build environment,
# the resulting binary loads cleanly on our ubuntu-based runtime.

ARG DUCKDB_TAG=v1.5.3
# Query-farm/tributary branch tracking the duckdb 1.5 line, pinned for reproducibility.
ARG TRIBUTARY_REF=aaedad15bfb43b15c678c93baad41251117f0574
# Out-of-tree httpfs pin — matches duckdb/.github/config/extensions/httpfs.cmake for v1.5.3.
ARG HTTPFS_GIT_TAG=52afb4204a3238d6ee132e83340f8d68c40ee91c
# vcpkg commit used by duckdb's v1.5 extension-ci-tools.
ARG VCPKG_COMMIT=84bab45d415d22042bd0b9081aea57f362da3f35

# --- Per-arch manylinux base selection (same images extension-ci-tools builds on) ---
FROM quay.io/pypa/manylinux_2_28_x86_64 AS toolchain-amd64
ENV DUCKDB_PLATFORM=linux_amd64 VCPKG_TRIPLET=x64-linux-release CMAKE_ARCH=x86_64

FROM quay.io/pypa/manylinux_2_28_aarch64 AS toolchain-arm64
ENV DUCKDB_PLATFORM=linux_arm64 VCPKG_TRIPLET=arm64-linux-release CMAKE_ARCH=aarch64

# --- Toolchain: build tools + recent cmake + vcpkg ---
FROM toolchain-${TARGETARCH} AS toolchain
ARG TARGETARCH
ARG VCPKG_COMMIT
RUN yum groupinstall -y "Development Tools" \
 && yum install -y curl zip unzip tar autoconf libtool ninja-build \
      perl-IPC-Cmd perl-core ccache bison flex git jq \
 && yum clean all && rm -rf /var/cache/yum
# DuckDB requires a recent CMake (the manylinux-packaged one is too old).
RUN cd /tmp \
 && curl -fLO https://github.com/Kitware/CMake/releases/download/v4.0.2/cmake-4.0.2-linux-${CMAKE_ARCH}.sh \
 && sh cmake-4.0.2-linux-${CMAKE_ARCH}.sh --skip-license --prefix=/usr/local \
 && rm cmake-4.0.2-linux-${CMAKE_ARCH}.sh
RUN git clone https://github.com/microsoft/vcpkg.git /vcpkg \
 && git -C /vcpkg checkout ${VCPKG_COMMIT} \
 && /vcpkg/bootstrap-vcpkg.sh
ENV VCPKG_ROOT=/vcpkg \
    VCPKG_TOOLCHAIN_PATH=/vcpkg/scripts/buildsystems/vcpkg.cmake \
    GEN=ninja \
    PATH=/vcpkg:$PATH
RUN git config --global --add safe.directory '*'

# --- Build: compile duckdb with tributary + httpfs + json statically linked ---
FROM toolchain AS build
ARG TARGETARCH
ARG DUCKDB_TAG
ARG TRIBUTARY_REF
ARG HTTPFS_GIT_TAG
WORKDIR /src
RUN git clone --recurse-submodules --shallow-submodules \
      https://github.com/Query-farm/tributary.git . \
 && git checkout ${TRIBUTARY_REF} && git submodule update --init --recursive \
 && git -C duckdb fetch --depth 1 origin tag ${DUCKDB_TAG} \
 && git -C duckdb checkout ${DUCKDB_TAG}

# Add httpfs (out-of-tree in 1.5) and openssl (its vcpkg dependency).
RUN printf '\n# Bundled by yolean/docker-base for https:// and gs:// support\nduckdb_extension_load(httpfs\n  GIT_URL https://github.com/duckdb/duckdb-httpfs\n  GIT_TAG %s\n)\n' "${HTTPFS_GIT_TAG}" >> extension_config.cmake \
 && jq '.dependencies += ["openssl"]' vcpkg.json > vcpkg.json.tmp && mv vcpkg.json.tmp vcpkg.json

# `make release` builds the whole tree and only fails on `plan_serializer`, a dev
# tool (gated by BUILD_SHELL, but not a dependency of the `duckdb` binary) that
# hits a link-time ODR clash under gcc-toolset-14. We then build the `duckdb`
# target explicitly, which never compiles that tool and surfaces real errors.
# Caches: ccache for duckdb objects, vcpkg buildtrees/packages/downloads for deps.
RUN --mount=type=cache,target=/ccache,id=duckdb-ccache-${TARGETARCH} \
    --mount=type=cache,target=/vcpkg/buildtrees,id=duckdb-vcpkg-bt-${TARGETARCH} \
    --mount=type=cache,target=/vcpkg/packages,id=duckdb-vcpkg-pkg-${TARGETARCH} \
    --mount=type=cache,target=/vcpkg/downloads,id=duckdb-vcpkg-dl-${TARGETARCH} \
    set -ex; \
    export CCACHE_DIR=/ccache CCACHE_MAXSIZE=2G \
      VCPKG_BINARY_SOURCES='clear;http,https://vcpkg-cache.duckdb.org,read' \
      VCPKG_TARGET_TRIPLET="$VCPKG_TRIPLET" VCPKG_HOST_TRIPLET="$VCPKG_TRIPLET" \
      OPENSSL_ROOT_DIR="/src/build/release/vcpkg_installed/$VCPKG_TRIPLET" \
      OPENSSL_DIR="/src/build/release/vcpkg_installed/$VCPKG_TRIPLET" \
      OPENSSL_USE_STATIC_LIBS=true \
      DUCKDB_PLATFORM="$DUCKDB_PLATFORM" DUCKDB_GIT_VERSION="$DUCKDB_TAG" \
      ENABLE_EXTENSION_AUTOLOADING=1 ENABLE_EXTENSION_AUTOINSTALL=1; \
    make release || true; \
    cmake --build build/release --target duckdb; \
    test -x build/release/duckdb; \
    strip build/release/duckdb; \
    ./build/release/duckdb -c "SELECT extension_name FROM duckdb_extensions() WHERE extension_name IN ('tributary','httpfs') AND loaded ORDER BY 1;"

# Stage the runtime artifacts here (as root) since the runtime image is nonroot.
RUN install -D build/release/duckdb /out/usr/local/bin/duckdb \
 && printf '#!/bin/sh\n' > /out/usr/local/bin/xdg-open \
 && chmod +x /out/usr/local/bin/xdg-open \
 && install -D /etc/pki/tls/certs/ca-bundle.crt /out/etc/ssl/certs/ca-certificates.crt

# --- Runtime ---
FROM --platform=$TARGETPLATFORM yolean/homedir

# duckdb resolves history/temp from $HOME; set it for both the root image and
# the nonroot user (whose home this is) that the to-nonroot variant runs as.
ENV HOME=/home/nonroot

# The runtime user is nonroot, so all files are staged in the build stage (as
# root) and copied in. ubuntu ships without a CA bundle; httpfs/openssl
# auto-discover /etc/ssl/certs/ca-certificates.crt. The xdg-open shim is a no-op
# for duckdb-ui (https://github.com/duckdb/duckdb-ui/discussions/84).
COPY --from=build /out/ /

ENTRYPOINT ["/usr/local/bin/duckdb"]
