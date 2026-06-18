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

# Create writable directories for model cache
RUN mkdir -p /data/models /data/cache \
    && chmod -R 777 /data

# Set cache/model dirs to writable paths
ENV KERYX_CACHE_DIR=/data/cache
ENV HF_HOME=/data/cache/huggingface
ENV HOME=/data

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/keryx-miner"]
CMD ["--mining-address", "keryx:REPLACE_WITH_YOUR_ADDRESS"]
