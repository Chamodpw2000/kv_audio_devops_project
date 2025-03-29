FROM node:20.11.1-bookworm-slim

WORKDIR /app



COPY package*.json ./

# Clean install with native rebuilding
RUN npm ci
# RUN npm rebuild bcrypt --build-from-source

COPY . .

CMD ["npm", "start"]
