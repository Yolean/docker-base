FROM yolean/builder-base

USER root

COPY --from=yolean/node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=yolean/node /usr/local/bin/node /usr/local/bin/
RUN cd /usr/local/bin && ln -s ../lib/node_modules/npm/bin/npm-cli.js npm

RUN npm install --ignore-scripts -g \
  rollup@2.18.2 \
  source-map-support@0.5.19 \
  typescript@3.9.7 \
  ts-node@8.10.2

USER nonroot:nogroup
