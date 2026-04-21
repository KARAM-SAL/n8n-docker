# Use the official n8n image (Debian-based)
FROM n8nio/n8n:latest

USER root

# Install poppler-utils (Debian uses apt-get, not apk)
RUN apt-get update && apt-get install -y --no-install-recommends poppler-utils && rm -rf /var/lib/apt/lists/*

# Install exceljs globally so the Code Node can find it
RUN npm install -g exceljs

# Create a persistent data directory
RUN mkdir -p /data && chmod 777 /data

# Make globally installed npm modules available to Code Nodes
ENV NODE_PATH=/usr/local/lib/node_modules

# Stay as root — Railway volumes mount as root
USER root

EXPOSE 5678