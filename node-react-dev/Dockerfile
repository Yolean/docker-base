FROM node:10.16.3-alpine@sha256:77c898d0da5e7bfb6e05c9a64de136ba4e03889a72f3c298e95df822a38f450d

RUN apk add --no-cache procps git curl ca-certificates

# basically npx create-react-app@3.1.1 my-app
RUN set -e; \
  mkdir -p /usr/src/app; \
  cd /usr/src/app; \
  npm install \
    react@16.9.0 \
    react-dom@16.9.0 \
    react-scripts@3.1.1 \
  ;
