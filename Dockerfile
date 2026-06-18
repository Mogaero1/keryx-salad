# Keryx Miner for SaladCloud — MINIMAL (no models baked)
FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download keryx-miner binary (correct filename pattern)
RUN KERYX_VERSION="v0.3.2-OPoI" && \
    echo "Installing keryx-miner ${KERYX_VERSION}" && \
    curl -L --retry 5 --retry-delay 10 -o /tmp/keryx.zip \
    "https://github.com/Keryx-Labs/keryx-miner/releases/download/${KERYX_VERSION}/keryx-miner-${KERYX_VERSION}-linux-gnu-amd64.zip" && \
    cd /tmp && unzip -o keryx.zip && \
    mv keryx-miner /usr/local/bin/keryx-miner && \
    chmod +x /usr/local/bin/keryx-miner && \
    rm -rf /tmp/keryx.zip

# Copy start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

WORKDIR /usr/local/bin

ENTRYPOINT ["/usr/local/bin/start.sh"]
