# Keryx Miner for SaladCloud
# PoW + OPoI (default mode) — supports all inference tiers
FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04

# Install minimal dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download latest keryx-miner release (linux-gnu-amd64)
ARG KERYX_VERSION=v0.3.2-OPoI
RUN wget -q "https://github.com/Keryx-Labs/keryx-miner/releases/download/${KERYX_VERSION}/keryx-miner-linux-gnu-amd64.zip" \
    -O /tmp/keryx.zip \
    && unzip -o /tmp/keryx.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/keryx-miner \
    && rm /tmp/keryx.zip

# Install CUDA runtime libs needed for OPoI inference
# (libcublas, libcurand already in nvidia/cuda:12.2.2-runtime base)

# Create non-root user
RUN useradd -m -s /bin/bash miner
USER miner
WORKDIR /home/miner

# Health check — miner should respond
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD pgrep keryx-miner || exit 1

# Default: PoW + OPoI (default inference tier)
# Override with --light, --high, --very-high, or --no-opoi via Salad command
ENTRYPOINT ["/usr/local/bin/keryx-miner"]
CMD ["--mining-address", "keryx:REPLACE_WITH_YOUR_ADDRESS"]
