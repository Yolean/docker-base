# Use built image from within build-contract
FROM yolean/node-kafka

COPY package.json .

COPY test-install.sh .

ENTRYPOINT ["./test-install.sh"]