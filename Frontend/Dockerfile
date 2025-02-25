FROM node:20.11.1-bookworm-slim

WORKDIR /app

# Install build essentials for native modules
# RUN apt-get update && apt-get install -y \
#     python3 \
#     make \
#     g++ \
#     && rm -rf /var/lib/apt/lists/*

COPY package*.json ./

# Clean install with native rebuilding
RUN npm ci
# RUN npm rebuild bcrypt --build-from-source

COPY . .

