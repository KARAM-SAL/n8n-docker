# Stage 1: Install system deps in Alpine (n8n's base is Alpine with apk removed)
FROM node:24-alpine AS deps-builder
RUN apk add --no-cache poppler-utils ghostscript

# Stage 2: The actual n8n image
FROM n8nio/n8n:latest

USER root

# Copy poppler binaries and libraries from the builder stage
COPY --from=deps-builder /usr/bin/pdftotext /usr/bin/pdftotext
COPY --from=deps-builder /usr/bin/pdftoppm /usr/bin/pdftoppm
COPY --from=deps-builder /usr/bin/pdfinfo /usr/bin/pdfinfo
COPY --from=deps-builder /usr/bin/pdfunite /usr/bin/pdfunite
COPY --from=deps-builder /usr/bin/pdfseparate /usr/bin/pdfseparate
COPY --from=deps-builder /usr/lib/libpoppler* /usr/lib/
COPY --from=deps-builder /usr/lib/libjpeg* /usr/lib/
COPY --from=deps-builder /usr/lib/libpng* /usr/lib/
COPY --from=deps-builder /usr/lib/libtiff* /usr/lib/
COPY --from=deps-builder /usr/lib/liblcms2* /usr/lib/
COPY --from=deps-builder /usr/lib/libopenjp2* /usr/lib/
COPY --from=deps-builder /usr/lib/libfreetype* /usr/lib/
COPY --from=deps-builder /usr/lib/libfontconfig* /usr/lib/
COPY --from=deps-builder /usr/lib/libexpat* /usr/lib/
COPY --from=deps-builder /usr/lib/libbrotli* /usr/lib/
COPY --from=deps-builder /usr/lib/libbz2* /usr/lib/
COPY --from=deps-builder /usr/lib/libstdc++* /usr/lib/
COPY --from=deps-builder /usr/lib/libgcc_s* /usr/lib/
COPY --from=deps-builder /usr/lib/libzstd* /usr/lib/
COPY --from=deps-builder /usr/lib/liblzma* /usr/lib/
COPY --from=deps-builder /usr/lib/libwebp* /usr/lib/
COPY --from=deps-builder /usr/lib/libsharpyuv* /usr/lib/

# Copy Ghostscript binary and libraries (needed by pdf-img-convert / n8n-nodes-pdfconvert)
# GraphicsMagick is already included in the n8n base image
COPY --from=deps-builder /usr/bin/gs /usr/bin/gs
COPY --from=deps-builder /usr/lib/libgs* /usr/lib/
COPY --from=deps-builder /usr/lib/libidn* /usr/lib/
COPY --from=deps-builder /usr/lib/libpaper* /usr/lib/
COPY --from=deps-builder /usr/share/ghostscript /usr/share/ghostscript

# Install exceljs globally so the Code Node can find it
RUN npm install -g exceljs

# Create a persistent data directory
RUN mkdir -p /data && chmod 777 /data

# Make globally installed npm modules available to Code Nodes
ENV NODE_PATH=/usr/local/lib/node_modules

# Stay as root — Railway volumes mount as root
USER root

EXPOSE 5678