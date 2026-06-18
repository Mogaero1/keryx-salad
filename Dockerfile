# Keryx Miner for SaladCloud
FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ARG KERYX_VERSION=v0.3.2-OPoI
RUN wget -q "https://github.com/Keryx-Labs/keryx-miner/releases/download/${KERYX_VERSION}/keryx-miner-${KERYX_VERSION}-linux-gnu-amd64.zip" \
    -O /tmp/keryx.zip \
    && unzip -o /tmp/keryx.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/keryx-miner \
    && rm /tmp/keryx.zip

RUN useradd -m -s /bin/bash miner
USER miner
WORKDIR /home/miner

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD pgrep keryx-miner || exit 1

ENTRYPOINT ["/usr/local/bin/keryx-miner"]
CMD ["--mining-address", "keryx:REPLACE_WITH_YOUR_ADDRESS"]
