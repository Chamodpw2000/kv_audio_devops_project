FROM node:20.11.1-bookworm-slim

WORKDIR /app



COPY package*.json ./

RUN npm ci

COPY . .




