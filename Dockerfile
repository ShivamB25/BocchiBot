# Base image
FROM node:19-alpine as builder

# Set working directory
WORKDIR /app

# Install build dependencies
RUN apk update && \
    apk add --no-cache \
    git

# Clone the repo
RUN git clone --depth=1 https://github.com/SlavyanDesu/BocchiBot.git .

# Copy config file
COPY config.json .

# Install dependencies
RUN npm install --only=production

# --- Production image ---

# Base image
FROM node:16-alpine

# Set working directory
WORKDIR /app

# Copy built files from builder
COPY --from=builder /app .

# Install runtime dependencies
RUN apk update && \
    apk add --no-cache \
    ffmpeg \
    tesseract-ocr

# Expose the port (if your bot listens on a specific port)
# EXPOSE 8080

# Run the bot
CMD ["node", "index.js"]
