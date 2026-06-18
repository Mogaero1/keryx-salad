# Keryx Miner for SaladCloud — ALL MODELS BAKED
FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create models directory structure
RUN mkdir -p /usr/local/bin/models/TinyLlama-1.1B \
    /usr/local/bin/models/DeepSeek-R1-8B \
    /usr/local/bin/models/DeepSeek-R1-32B

# Download TinyLlama 1.1B (~2.2 GB)
RUN echo "=== Downloading TinyLlama 1.1B ===" && \
    curl -L --retry 5 --retry-delay 10 --retry-max-time 600 \
    -o /usr/local/bin/models/TinyLlama-1.1B/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf \
    "https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf" && \
    echo "TinyLlama OK: $(du -sh /usr/local/bin/models/TinyLlama-1.1B/ | cut -f1)"

# Download DeepSeek-R1-8B (~5 GB)
RUN echo "=== Downloading DeepSeek-R1-8B ===" && \
    curl -L --retry 5 --retry-delay 10 --retry-max-time 1200 \
    -o /usr/local/bin/models/DeepSeek-R1-8B/DeepSeek-R1-Distill-Qwen-8B-Q4_K_M.gguf \
    "https://huggingface.co/unsloth/DeepSeek-R1-Distill-Qwen-8B-GGUF/resolve/main/DeepSeek-R1-Distill-Qwen-8B-Q4_K_M.gguf" && \
    echo "DeepSeek-8B OK: $(du -sh /usr/local/bin/models/DeepSeek-R1-8B/ | cut -f1)"

# Download DeepSeek-R1-32B (~20 GB)
RUN echo "=== Downloading DeepSeek-R1-32B ===" && \
    curl -L --retry 5 --retry-delay 10 --retry-max-time 3600 \
    -o /usr/local/bin/models/DeepSeek-R1-32B/DeepSeek-R1-Distill-Qwen-32B-Q4_K_M.gguf \
    "https://huggingface.co/unsloth/DeepSeek-R1-Distill-Qwen-32B-GGUF/resolve/main/DeepSeek-R1-Distill-Qwen-32B-Q4_K_M.gguf" && \
    echo "DeepSeek-32B OK: $(du -sh /usr/local/bin/models/DeepSeek-R1-32B/ | cut -f1)"

# Download keryx-miner binary
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
