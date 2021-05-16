FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

# set version label
LABEL maintainer="edifus"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"

ENV KEYS="generate"
ENV HARVESTER_ONLY="false"
ENV FARMER_ONLY="false"
ENV NODE_ONLY="false"
ENV WALLET_ONLY="false"
ENV PLOTS_DIR="/plots"
ENV FARMER_ADDRESS="null"
ENV FARMER_PORT="null"
ENV NODE_ADDRESS="null"
ENV TESTNET="false"
ENV FULL_NODE_PORT="null"
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
      python3.7-venv \
      python3.7-distutils && \
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

# node = 8444 | farmer = 8447 | wallet = 8449 | ui = 55400
EXPOSE 8444 8447 8449 55400
VOLUME /plots /config
