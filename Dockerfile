# Stage 1: Install poppler-utils in Alpine (same base as n8n)
FROM node:24-alpine AS poppler-builder
RUN apk add --no-cache poppler-utils ghostscript

# Stage 2: The actual n8n image
FROM n8nio/n8n:latest

USER root

# Copy poppler binaries and libraries from the builder stage
COPY --from=poppler-builder /usr/bin/pdftotext /usr/bin/pdftotext
COPY --from=poppler-builder /usr/bin/pdftoppm /usr/bin/pdftoppm
COPY --from=poppler-builder /usr/bin/pdfinfo /usr/bin/pdfinfo
COPY --from=poppler-builder /usr/bin/pdfunite /usr/bin/pdfunite
COPY --from=poppler-builder /usr/bin/pdfseparate /usr/bin/pdfseparate
COPY --from=poppler-builder /usr/lib/libpoppler* /usr/lib/
COPY --from=poppler-builder /usr/lib/libjpeg* /usr/lib/
COPY --from=poppler-builder /usr/lib/libpng* /usr/lib/
COPY --from=poppler-builder /usr/lib/libtiff* /usr/lib/
COPY --from=poppler-builder /usr/lib/liblcms2* /usr/lib/
COPY --from=poppler-builder /usr/lib/libopenjp2* /usr/lib/
COPY --from=poppler-builder /usr/lib/libfreetype* /usr/lib/
COPY --from=poppler-builder /usr/lib/libfontconfig* /usr/lib/
COPY --from=poppler-builder /usr/lib/libexpat* /usr/lib/
COPY --from=poppler-builder /usr/lib/libbrotli* /usr/lib/
COPY --from=poppler-builder /usr/lib/libbz2* /usr/lib/
COPY --from=poppler-builder /usr/lib/libstdc++* /usr/lib/
COPY --from=poppler-builder /usr/lib/libgcc_s* /usr/lib/
COPY --from=poppler-builder /usr/lib/libzstd* /usr/lib/
COPY --from=poppler-builder /usr/lib/liblzma* /usr/lib/
COPY --from=poppler-builder /usr/lib/libwebp* /usr/lib/
COPY --from=poppler-builder /usr/lib/libsharpyuv* /usr/lib/

# Install exceljs globally so the Code Node can find it
RUN npm install -g exceljs

# Remove node-npm-pdf2image — it does not support Linux and causes crashes
RUN npm uninstall -g node-npm-pdf2image || true

# Create a persistent data directory
RUN mkdir -p /data && chmod 777 /data

# Make globally installed npm modules available to Code Nodes
ENV NODE_PATH=/usr/local/lib/node_modules

# Stay as root — Railway volumes mount as root
USER root

# Install GraphicsMagick and Ghostscript for n8n-nodes-pdfconvert (pdf-img-convert)
RUN apt-get update && apt-get install -y graphicsmagick ghostscript && rm -rf /var/lib/apt/lists/*

EXPOSE 5678