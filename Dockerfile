FROM ghcr.io/linuxserver/baseimage-alpine:3.18

# set version label
ARG BUILD_DATE
ARG VERSION
ARG KAVITA_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ENV HOME="/config"

RUN \
  apk add --no-cache \
    icu-libs && \
  echo "**** install kavita ****" && \
  mkdir -p \
    /app/kavita && \
  if [ -z ${KAVITA_RELEASE+x} ]; then \
    KAVITA_RELEASE=$(curl -sX GET "https://api.github.com/repos/kareadita/kavita/releases/latest" \
      | jq -r '.tag_name'); \
  fi && \
  curl -o \
    /tmp/kavita.tar.gz -fL \
    "https://github.com/Kareadita/Kavita/releases/download/${KAVITA_RELEASE}/kavita-linux-musl-x64.tar.gz" && \
  tar xf \
    /tmp/kavita.tar.gz -C \
    /app/kavita --strip-components=1 && \
  chmod +x /app/kavita/Kavita && \
  cp /app/kavita/config/appsettings.json /defaults/ && \
  rm -rf /app/kavita/config && \
  ln -s /config /app/kavita/config && \
  echo "**** clean up ****" && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 5000
