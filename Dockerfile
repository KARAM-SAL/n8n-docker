FROM n8nio/n8n

USER root
RUN apt-get update && apt-get install -y poppler-utils
USER node