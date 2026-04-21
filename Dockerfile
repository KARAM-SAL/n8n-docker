# We specify -alpine to ensure 'apk' exists
FROM n8nio/n8n:latest-alpine

USER root

# 1. Install dependencies using Alpine's manager (apk)
RUN apk add --no-cache poppler-utils

# 2. Install exceljs globally
RUN npm install -g exceljs

# 3. Create a data directory that is completely wide open
# This fixes the "EACCES: permission denied" error
RUN mkdir -p /data && chmod 777 /data

# 4. Tell n8n to use this new folder
ENV N8N_USER_FOLDER=/data
ENV NODE_PATH=/usr/local/lib/node_modules

# Stay as root to bypass all permission hurdles on Railway
USER root