# syntax=docker/dockerfile:1
FROM rust:1.76-slim AS builder
WORKDIR /src
COPY Cargo.toml Cargo.lock* ./
RUN mkdir -p src && echo "fn main(){}" > src/main.rs
RUN cargo build --release
COPY . .
RUN cargo build --release

FROM gcr.io/distroless/cc-debian12:nonroot
WORKDIR /app
COPY --from=builder /src/target/release/rust-service /app/rust-service
EXPOSE 8080
ENV PORT=8080
ENTRYPOINT ["/app/rust-service"]