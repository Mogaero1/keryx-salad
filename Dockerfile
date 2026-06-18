# Keryx Miner for SaladCloud — MINIMAL (no models baked)
FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download keryx-miner binary
RUN KERYX_VERSION=$(curl -sL "https://api.github.com/repos/Keryx-Labs/keryx-miner/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4) && \
    echo "Installing keryx-miner ${KERYX_VERSION}" && \
    curl -L --retry 5 --retry-delay 10 -o /tmp/keryx.zip \
    "https://github.com/Keryx-Labs/keryx-miner/releases/download/${KERYX_VERSION}/keryx-miner-${KERYX_VERSION}-x86_64-unknown-linux-gnu.zip" && \
    cd /tmp && unzip -o keryx.zip && \
    mv keryx-miner-*/keryx-miner /usr/local/bin/keryx-miner && \
    chmod +x /usr/local/bin/keryx-miner && \
    rm -rf /tmp/keryx.zip /tmp/keryx-miner-*

# Copy start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

WORKDIR /usr/local/bin

ENTRYPOINT ["/usr/local/bin/start.sh"]
