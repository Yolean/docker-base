FROM --platform=$TARGETPLATFORM yolean/node-kafka:root

# Appends the same nonroot directives as https://github.com/Yolean/kubernetes-kafka/tree/master/nonroot
# i.e. https://github.com/solsson/dockerfiles/tree/native/kafka-nonroot
RUN grep 'nonroot:x:65532' /etc/passwd || \
  echo 'nonroot:x:65532:65534:nonroot:/home/nonroot:/usr/sbin/nologin' >> /etc/passwd && \
  mkdir -p /home/nonroot && touch /home/nonroot/.bash_history && chown -R 65532:65534 /home/nonroot
USER nonroot:nogroup
