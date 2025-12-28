# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:alpine323

# set version label
ARG BUILD_DATE
ARG VERSION
ARG FILEZILLA_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Filezilla

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/filezilla-logo.png && \
  echo "**** install packages ****" && \
  if [ -z ${FILEZILLA_VERSION+x} ]; then \
    FILEZILLA_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.22/community/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
    && awk '/^P:filezilla$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
  fi && \
  apk add --no-cache \
    filezilla==${FILEZILLA_VERSION} \
    filezilla-lang && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3001

VOLUME /config
