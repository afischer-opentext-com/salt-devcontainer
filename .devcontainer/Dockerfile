FROM ubuntu:eoan

LABEL MAINTAINER=afischer@opentext.com

# Shutup apt-get
ARG DEBIAN_FRONTEND=noninteractive
ARG SALT_REPO=https://github.com/saltstack/salt
ARG BASE_DIR=/workspace
USER root

# Upgrade Base system
# Utilities and required third party packages
RUN set -ex && \
  apt-get --yes --quiet --no-install-recommends update && \
  apt-get --yes --quiet --no-install-recommends dist-upgrade --option Dpkg::Options::="--force-confold" && \
  apt-get --yes --quiet --install-recommends --option Dpkg::Options::="--force-confold" install \
    gnupg \
    gpg-agent \
    ca-certificates \
    curl \
    wget \
    inotify-tools \
    moreutils \
    apt-utils \
    dialog \
    openssh-client \
    less \iproute2 \
    procps \
    lsb-release \
    git \
    build-essential \
    libssl-dev \
    python3 \
    python3-dev \
    python3-m2crypto \
    python3-pip

# Path setup for local Pips
ENV PATH="/root/.local/bin;${PATH}"

# Cleanup
RUN set -ex && \
  apt-get --yes --quiet autoremove && \
  apt-get --yes --quiet autoclean && \
  apt-get --yes --quiet clean && \
  rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN set -ex && \
  mkdir --parents "${BASE_DIR}"
