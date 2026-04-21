# We use the specific Alpine image because it's much smaller and 
# usually has fewer permission issues on Railway
FROM n8nio/n8n:latest

USER root

# 1. Install dependencies
# 'apk' is back because the latest n8n-alpine images are stable again
RUN apk add --no-cache poppler-utils

# 2. Install exceljs globally
RUN npm install -g exceljs

# 3. Create a data directory that is completely wide open
RUN mkdir -p /data && chmod 777 /data

# 4. Tell n8n to use this new folder
ENV N8N_USER_FOLDER=/data
ENV NODE_PATH=/usr/local/lib/node_modules

# Stay as root to bypass all "Permission Denied" errors
USER root