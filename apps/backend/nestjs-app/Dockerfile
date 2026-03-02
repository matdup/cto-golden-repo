# syntax=docker/dockerfile:1
FROM node:20-alpine

WORKDIR /app

# Minimal runtime. We keep it honest: this is a placeholder until Nest build exists.
COPY package.json ./
RUN npm -s install || true

COPY . .

ENV NODE_ENV=production
ENV PORT=8080

EXPOSE 8080
CMD ["node", "src/main.ts"]