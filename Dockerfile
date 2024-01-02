FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine319

# set version label
ARG BUILD_DATE
ARG VERSION
ARG FILEZILLA_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Filezilla

RUN \
  echo "**** install packages ****" && \
  if [ -z ${FILEZILLA_VERSION+x} ]; then \
    FILEZILLA_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.19/community/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
    && awk '/^P:filezilla$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
  fi && \
  apk add --no-cache \
    filezilla==${FILEZILLA_VERSION} \
    filezilla-lang && \
  sed -i 's|</applications>|  <application title="FileZilla" type="normal">\n    <maximized>yes</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
