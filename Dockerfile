# Stage 1: Install all system deps and collect their shared libraries
FROM node:24-alpine AS deps-builder
RUN apk add --no-cache poppler-utils ghostscript

# Automatically find ALL shared library dependencies for gs and poppler tools
RUN mkdir -p /deps/bin /deps/lib /deps/share \
    && cp /usr/bin/gs /deps/bin/ \
    && cp /usr/bin/pdftotext /usr/bin/pdftoppm /usr/bin/pdfinfo \
       /usr/bin/pdfunite /usr/bin/pdfseparate /deps/bin/ \
    && cp -r /usr/share/ghostscript /deps/share/ \
    && for bin in gs pdftotext pdftoppm pdfinfo pdfunite pdfseparate; do \
         ldd /usr/bin/$bin 2>/dev/null \
         | grep "=> /" \
         | awk '{print $3}'; \
       done | sort -u | while read lib; do \
         cp "$lib" /deps/lib/ 2>/dev/null || true; \
       done

# Stage 2: The actual n8n image
FROM n8nio/n8n:latest

USER root

# Copy all collected binaries, libraries, and ghostscript data
COPY --from=deps-builder /deps/bin/ /usr/bin/
COPY --from=deps-builder /deps/lib/ /usr/lib/
COPY --from=deps-builder /deps/share/ghostscript /usr/share/ghostscript

# Install exceljs globally so the Code Node can find it
RUN cd /usr/local/lib/node_modules/n8n && npm install exceljs

# Create a persistent data directory
RUN mkdir -p /data && chmod 777 /data



# Stay as root — Railway volumes mount as root
USER root

EXPOSE 5678