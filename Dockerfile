FROM n8nio/n8n:latest

USER root

# Update and install poppler-utils using Debian's package manager
RUN apt-get update && \
    apt-get install -y poppler-utils && \
    rm -rf /var/lib/apt/lists/*

USER node