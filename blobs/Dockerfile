FROM --platform=$TARGETPLATFORM alpine:3.19@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b

RUN set -eux; \
	apk add --no-cache \
		bzip2 \
		coreutils \
		curl \
		gcc \
		gnupg \
		linux-headers \
		make \
		musl-dev \
		patch \
		tzdata \
# busybox's tar ironically does not maintain mtime of directories correctly (which we need for SOURCE_DATE_EPOCH / reproducibility)
		tar \
	;

# pub   1024D/ACC9965B 2006-12-12
#       Key fingerprint = C9E9 416F 76E6 10DB D09D  040F 47B7 0C55 ACC9 965B
# uid                  Denis Vlasenko <vda.linux@googlemail.com>
# sub   1024g/2C766641 2006-12-12
RUN mkdir -p ~/.gnupg && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys C9E9416F76E610DBD09D040F47B70C55ACC9965B

# https://busybox.net: 19 May 2023
ENV BUSYBOX_VERSION 1.36.1
ENV BUSYBOX_SHA256 b8cc24c9574d809e7279c3be349795c5d5ceb6fdf19ca709f80cde50e47de314

RUN set -eux; \
	tarball="busybox-${BUSYBOX_VERSION}.tar.bz2"; \
	curl -fL -o busybox.tar.bz2.sig "https://busybox.net/downloads/$tarball.sig"; \
	curl -fL -o busybox.tar.bz2 "https://busybox.net/downloads/$tarball"; \
	echo "$BUSYBOX_SHA256 *busybox.tar.bz2" | sha256sum -c -; \
	gpg --batch --verify busybox.tar.bz2.sig busybox.tar.bz2; \
# Alpine... 😅
	mkdir -p /usr/src; \
	tar -xf busybox.tar.bz2 -C /usr/src "busybox-$BUSYBOX_VERSION"; \
	mv "/usr/src/busybox-$BUSYBOX_VERSION" /usr/src/busybox; \
	rm busybox.tar.bz2*; \
	\
# save the tarball's filesystem timestamp persistently (in case building busybox modifies it) so we can use it for reproducible rootfs later
	SOURCE_DATE_EPOCH="$(stat -c '%Y' /usr/src/busybox | tee /usr/src/busybox.SOURCE_DATE_EPOCH)"; \
	date="$(date -d "@$SOURCE_DATE_EPOCH" '+%Y%m%d%H%M.%S')"; \
	touch -t "$date" /usr/src/busybox.SOURCE_DATE_EPOCH; \
# for logging validation/edification
	date --date "@$SOURCE_DATE_EPOCH" --rfc-2822

WORKDIR /usr/src/busybox

RUN set -eux; \
	\
# build date/time gets embedded in the BusyBox binary -- SOURCE_DATE_EPOCH should override that
	SOURCE_DATE_EPOCH="$(cat /usr/src/busybox.SOURCE_DATE_EPOCH)"; \
	export SOURCE_DATE_EPOCH; \
# (has to be set in the config stage for making sure "AUTOCONF_TIMESTAMP" is embedded correctly)
	\
	setConfs=' \
		CONFIG_LS=y \
		CONFIG_CP=y \
		CONFIG_AR=y \
		CONFIG_FEATURE_AR_CREATE=y \
		CONFIG_FEATURE_AR_LONG_FILENAMES=y \
# CONFIG_LAST_SUPPORTED_WCHAR: see https://github.com/docker-library/busybox/issues/13 (UTF-8 input)
		CONFIG_LAST_SUPPORTED_WCHAR=0 \
		CONFIG_STATIC=y \
	'; \
	\
	unsetConfs=' \
		CONFIG_FEATURE_SYNC_FANCY \
		\
# see https://wiki.musl-libc.org/wiki/Building_Busybox
		CONFIG_FEATURE_HAVE_RPC \
		CONFIG_FEATURE_INETD_RPC \
		CONFIG_FEATURE_UTMP \
		CONFIG_FEATURE_WTMP \
	'; \
	\
	make allnoconfig; \
	\
	for conf in $unsetConfs; do \
		sed -i \
			-e "s!^$conf=.*\$!# $conf is not set!" \
			.config; \
	done; \
	\
	for confV in $setConfs; do \
		conf="${confV%=*}"; \
		sed -i \
			-e "s!^$conf=.*\$!$confV!" \
			-e "s!^# $conf is not set\$!$confV!" \
			.config; \
		if ! grep -q "^$confV\$" .config; then \
			echo "$confV" >> .config; \
		fi; \
	done;

RUN set -eux; \
	nproc="$(nproc)"; \
	make -j "$nproc" busybox;

FROM --platform=$TARGETPLATFORM alpine:3.19@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b as bin

WORKDIR /target

COPY --from=0 /usr/src/busybox/busybox ./busybox

RUN set -eux; \
  ln -s ./busybox ./cp; \
  ln -s ./busybox ./ls; \
  ls -lh .

FROM --platform=$TARGETPLATFORM scratch

USER 65532:65534

COPY --from=bin /target /bin

WORKDIR /blobs
ENTRYPOINT [ "/bin/cp" ]
# our binary has no help section
CMD [ "requires-cp-args", "/tmp/to/somewhere" ]
