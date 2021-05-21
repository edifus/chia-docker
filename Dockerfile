FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

# set version label
LABEL maintainer="edifus"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"

ENV KEYS="generate"
ENV FULL_NODE="true"
ENV HARVESTER_ONLY="false"
ENV FARMER_ONLY="false"
ENV NODE_ONLY="false"
ENV WALLET_ONLY="false"
ENV LOG_LEVEL="INFO"
ENV TAIL_DEBUG_LOGS="false"
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
    git clone https://github.com/Chia-Network/chia-blockchain.git --branch latest --recurse-submodules && \
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

COPY root/ /

# node = 8444 | farmer = 8447
EXPOSE 8444 8447

VOLUME /config
