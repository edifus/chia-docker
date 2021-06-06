FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

# set version label
LABEL maintainer="edifus"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config"

# install chia-blockchain
RUN apt-get update && \
    apt-get install -y \
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
      python3.8-distutils && \
    echo "**** cloning latest chia-blockchain ****" && \
    CHIA_RELEASE=$(curl -sX GET "https://api.github.com/repos/Chia-Network/chia-blockchain/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]') && \
    git clone https://github.com/Chia-Network/chia-blockchain.git --branch latest --recurse-submodules="mozilla-ca" && \
    git -C /chia-blockchain fetch && \
    git -C /chia-blockchain checkout ${CHIA_RELEASE} && \
    cd /chia-blockchain && \
    /bin/sh ./install.sh && \
    mkdir /plots && \
    chown abc:abc -R /plots /config /chia-blockchain && \
    echo "**** cleanup ****" && \
    apt-get clean && \
    rm -rf \
  	  /tmp/* \
  	  /var/lib/apt/lists/* \
  	  /var/tmp/*

# copy local files
COPY root/ /

# node = 8444 | farmer = 8447
EXPOSE 8444 8447

# chia configuration
VOLUME /config
