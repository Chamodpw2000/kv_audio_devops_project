# Development stage for building
FROM node:20.11.1-bookworm-slim as development

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:20.11.1-bookworm-slim as production

WORKDIR /app

# Install serve - a static file server
RUN npm install -g serve

# Copy built files from development stage
COPY --from=development /app/dist ./dist

# Expose port
EXPOSE 5173

# Run as non-root user
USER node

# Start the server on port 5173
CMD ["serve", "-s", "dist", "-l", "5173"]
