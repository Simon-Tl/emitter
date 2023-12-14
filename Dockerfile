FROM rust:1.72 as builder

WORKDIR /build
COPY . .

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        cmake \
        clang \
        llvm \
        gcc; \
    rm -rf /var/lib/apt/lists/*

RUN cd /build && cargo build --release


FROM debian:stable

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl jq \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /build/target/release/emitter /app/emitter