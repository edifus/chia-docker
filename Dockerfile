FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

# set version label
LABEL maintainer="edifus"

# environment variables
ENV DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config"

# install chia-blockchain
RUN apt-get update \
    && apt-get install -y \
      curl \
      jq \
      bc \
      python3 \
      tar \
      lsb-release \
      ca-certificates \
      git \
      sudo \
      openssl \
      unzip \
      wget \
      python3-pip \
      build-essential \
      python3-dev \
      python3.8-venv \
      python3.8-distutils \
    && echo "**** cloning latest chia-blockchain ****" \
    && git clone https://github.com/foxypool/chia-blockchain.git --branch latest --recurse-submodules="mozilla-ca" /app/chia-blockchain \
    && git -C /app/chia-blockchain fetch \
    && git -C /app/chia-blockchain checkout main \
    && cd /app/chia-blockchain \
    && /bin/sh ./install.sh \
    && mkdir /plots \
    && chown abc:abc -R /plots /config /app/chia-blockchain \
    && echo "**** cleanup ****" \
    && apt-get clean \
    && rm -rf \
  	  /tmp/* \
  	  /var/lib/apt/lists/* \
  	  /var/tmp/*

# copy local files
COPY root/ /

# node = 8444 | farmer = 8447
EXPOSE 8444 8447

# chia configuration
VOLUME /config
