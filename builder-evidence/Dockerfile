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

ENV NODE_PATH=/usr/local/lib/node_modules

RUN npm install -g --ignore-scripts node-gyp@latest
RUN npm install -g duckdb@latest

FROM --platform=$TARGETPLATFORM yolean/builder-base-gcloud

RUN y-parquet-tools -h
COPY --from=node-gyp /usr/local/bin/duckdb /usr/local/bin/duckdb

ENV NODE_PATH=/usr/local/lib/node_modules

COPY --from=node-gyp /usr/local/lib/node_modules/duckdb /usr/local/lib/node_modules/duckdb
RUN npm install -g --ignore-scripts duckdb-async@latest && rm -r /usr/local/lib/node_modules/duckdb-async/node_modules/duckdb

# NODE_PATH doesn't work for ESM
RUN mkdir /workspace/node_modules \
  && ln -s /usr/local/lib/node_modules/duckdb /workspace/node_modules/duckdb \
  && ln -s /usr/local/lib/node_modules/duckdb-async /workspace/node_modules/duckdb-async

RUN node -e 'import { Database } from "duckdb-async"; console.log(await (await Database.create(":memory:")).all("PRAGMA version"))'
