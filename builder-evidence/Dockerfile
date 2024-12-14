# https://github.com/Yolean/ystack/tree/76cda0be841219194bd07c6d7cacc065293e7625/lib includes nodejs
FROM --platform=$TARGETPLATFORM yolean/builder-base-gcc as node-gyp
ARG TARGETARCH

USER root
RUN set -ex; \
  ARCH=$TARGETARCH; \
  [ "$TARGETARCH" != "arm64" ] || ARCH=aarch64; \
  curl -sLS -o /tmp/duckdb.zip https://github.com/duckdb/duckdb/releases/download/v1.1.3/duckdb_cli-linux-$ARCH.zip; \
  cd /usr/local/bin && unzip /tmp/duckdb.zip; \
  duckdb --version
USER nonroot:nogroup

RUN set -ex; \
  git config --global --add safe.directory /workspace; \
  git init .; \
  git remote add origin https://github.com/Yolean/evidence-template; \
  git fetch origin; \
  git checkout origin/support-v3-bi

RUN npm install --ignore-scripts --strict-peer-deps
RUN cd node_modules/duckdb && npm run install

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcloud

RUN y-parquet-tools -h
COPY --from=node-gyp /usr/local/bin/duckdb /usr/local/bin/duckdb

COPY --from=node-gyp /workspace/node_modules /workspace/node_modules
COPY --from=node-gyp /workspace/package-lock.json /workspace/

RUN node -e 'import { Database } from "duckdb-async"; console.log(await (await Database.create(":memory:")).all("PRAGMA version"))'

RUN npm ls @evidence-dev/core-components \
  && npm ls @evidence-dev/duckdb \
  && npm ls @evidence-dev/evidence \
  && du -sh node_modules
