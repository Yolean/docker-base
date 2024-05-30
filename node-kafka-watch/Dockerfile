FROM --platform=$TARGETPLATFORM yolean/node-watchexec:root as watchexec

FROM --platform=$TARGETPLATFORM yolean/node-kafka:root

COPY --from=watchexec --chown=0:0 /usr/local/bin/watchexec /usr/local/bin

WORKDIR /app

COPY --from=watchexec --chown=nonroot:nogroup /app/main.js main.js

ENTRYPOINT [ "/usr/local/bin/watchexec", \
  "--print-events", \
  "--debounce=500", \
  "--shell=none", \
  "--watch=/app", \
  "-r", \
  "--", \
  "/usr/local/bin/node" ]
CMD [ "./main.js" ]
