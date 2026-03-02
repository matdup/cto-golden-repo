# syntax=docker/dockerfile:1

FROM golang:1.22-alpine AS builder

WORKDIR /src

# Speed up builds + deterministic deps
COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/api ./cmd/api

FROM gcr.io/distroless/base-debian12:nonroot

WORKDIR /app
COPY --from=builder /out/api ./api

EXPOSE 8080
ENV PORT=8080
ENTRYPOINT ["/app/api"]