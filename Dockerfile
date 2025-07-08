FROM debian:trixie-slim

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/erikparra/docker-steamcmd-server"

RUN  echo "deb http://deb.debian.org/debian trixie contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
	apt-get update && apt-get -y upgrade && \
	apt-get -y install --no-install-recommends wget locales procps && \
	touch /etc/locale.gen && \
	echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
	locale-gen && \
	apt-get -y install --reinstall ca-certificates && \
	rm -rf /var/lib/apt/lists/*


RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt -y install gnupg2 gcc-14 alsa-utils && \
	mkdir -pm755 /etc/apt/keyrings && \
	wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -  && \
	wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources  && \
	apt-get update && \
	apt -y install --no-install-recommends winehq-devel && \
	apt-get -y install screen xvfb winbind && \
	apt-get -y install gnutls-bin && \
	apt-get -y --purge remove gnupg2 && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/*


ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="template"
ENV UPDATE_PUBLIC_IP="false"
ENV BACKUP="false"
ENV BACKUP_INTERVAL=360
ENV BACKUPS_TO_KEEP=8
ENV GAME_PARAMS=""
ENV VALIDATE=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV USERNAME=""
ENV PASSWRD=""
ENV USER="steam"
ENV DATA_PERM=770

RUN mkdir $DATA_DIR && \
	mkdir $STEAMCMD_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]
