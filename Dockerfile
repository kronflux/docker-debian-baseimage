# Base image
FROM debian:bookworm-slim

# Metadata
LABEL org.opencontainers.image.authors="richard@rmoser.ca"
LABEL org.opencontainers.image.source="https://github.com/kronflux/docker-debian-baseimage"

# Build arguments
ARG DEBIAN_FRONTEND=noninteractive

# Environment variables
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Configure package repositories
RUN echo "" > /etc/apt/sources.list && \
    rm -f /etc/apt/sources.list.d/* && \
    echo "deb http://deb.debian.org/debian bookworm contrib main non-free non-free-firmware" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bookworm-updates contrib main non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian-security bookworm-security contrib main non-free non-free-firmware" >> /etc/apt/sources.list

# Update system and configure locales
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends locales && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8

# Configure certificates and architecture support
RUN apt-get -y install --reinstall ca-certificates && \
    dpkg --add-architecture i386 && \
    apt-get update

# Install essential packages
RUN apt-get -y install --no-install-recommends \
        curl \
        cron \
        gettext \
        iproute2 \
        jq \
        locales \
        numactl \
        procps \
        screen \
        tzdata \
        unzip \
        wget \
        xauth

# Clean up package cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
