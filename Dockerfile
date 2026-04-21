# We specify -debian to ensure we aren't getting an old Alpine cache
FROM n8nio/n8n:latest-debian

USER root

RUN apt-get update && \
    apt-get install -y poppler-utils && \
    rm -rf /var/lib/apt/lists/*

USER node