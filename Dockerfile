# 1. Use the correct Alpine tag
FROM n8nio/n8n:alpine

USER root

# 2. Install poppler-utils (Alpine uses apk)
RUN apk add --no-cache poppler-utils

# 3. Install exceljs globally so the Code Node can find it
RUN npm install -g exceljs

# 4. Create a data directory at the root to avoid permission ghosts
RUN mkdir -p /data && chmod 777 /data

# 5. Tell n8n where to save everything
ENV N8N_USER_FOLDER=/data
ENV NODE_PATH=/usr/local/lib/node_modules

# Stay as root so Railway volumes don't lock you out
USER root