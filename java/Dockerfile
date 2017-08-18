FROM yolean/preferred-from

ENV ZULU_OPENJDK_VERSION="8=8.23.0.3"

RUN set -ex; \
  runDeps=''; \
  buildDeps='gnupg dirmngr'; \
  export DEBIAN_FRONTEND=noninteractive; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9; \
  echo 'deb http://repos.azulsystems.com/debian stable main' > /etc/apt/sources.list.d/zulu.list; \
  mkdir /usr/share/man/man1; \
  apt-get update && apt-get install -y zulu-${ZULU_OPENJDK_VERSION} --no-install-recommends; \
  rm -rf /usr/share/man/man1; \
  \
  cd /usr/lib/jvm/zulu-8-amd64/; \
  rm -rf demo man sample src.zip; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/apt /var/log/dpkg.log /var/log/alternatives.log

ENV JAVA_HOME=/usr/lib/jvm/zulu-8
