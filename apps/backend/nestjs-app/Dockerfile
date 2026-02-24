# Placeholder Dockerfile for nestjs-app
FROM node:20-alpine
WORKDIR /app
COPY package.json ./
RUN npm -s install || true
COPY . .
CMD ["node", "src/main.ts"]
