FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o api ./cmd/api

FROM alpine:latest
RUN adduser -D appuser
WORKDIR /home/appuser
COPY --from=builder /app/api .
USER appuser
EXPOSE 8080
CMD ["./api"]