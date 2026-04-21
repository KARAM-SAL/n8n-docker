# Use the official n8n image (already Alpine-based)
FROM n8nio/n8n:latest

USER root

# Install poppler-utils (for PDF processing)
RUN apk add --no-cache poppler-utils

# Install exceljs globally so the Code Node can find it
RUN npm install -g exceljs

# Create a persistent data directory
RUN mkdir -p /data && chmod 777 /data

# Make globally installed npm modules available to Code Nodes
ENV NODE_PATH=/usr/local/lib/node_modules

# Stay as root — Railway volumes mount as root and will cause
# permission errors if n8n runs as the 'node' user.
# (Your Railway env var N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false handles this)
USER root

EXPOSE 5678