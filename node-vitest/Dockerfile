# syntax=docker/dockerfile:1.4

FROM --platform=$TARGETPLATFORM yolean/node:root

ENV NODE_PATH=/usr/local/lib/node_modules

RUN mkdir /workspace && chown 65532:65534 /workspace
COPY package.json /workspace/

WORKDIR /workspace
RUN npm install --ignore-scripts && chown 65532:65534 node_modules
ENTRYPOINT ["./node_modules/.bin/vitest"]
CMD ["run"]
