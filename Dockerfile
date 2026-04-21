FROM n8nio/n8n:latest-debian

USER root

RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y poppler-utils && \
    npm install -g exceljs && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

USER node