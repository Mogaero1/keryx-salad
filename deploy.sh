#!/bin/bash
# Keryx Miner — SaladCloud Deploy Script
# Build, push to GHCR, and provide Salad deployment config
set -e

# ========================
# CONFIG — EDIT THIS
# ========================
WALLET="keryx:qz8x35t7fzf97s09vyy2puyqx370wxc2m6pmq7vxvputm5t5v5w7uf826gsr9"
GITHUB_USER="0xmultiserver-crypto"  # Ganti dengan GitHub username lu
IMAGE_NAME="ghcr.io/${GITHUB_USER}/keryx-miner:latest"
KERYX_VERSION="v0.3.2-OPoI"

# Mining mode: default (PoW+OPoI), --light (4GB VRAM), --no-opoi (PoW only)
MINING_FLAGS=""  # Kosongkan untuk default, atau: "--light" / "--no-opoi"

# ========================
# BUILD & PUSH
# ========================
echo "🔨 Building Keryx Miner Docker image..."
cd "$(dirname "$0")"

# Login ke GHCR (perlu GitHub Personal Access Token dengan write:packages)
echo "📦 Login ke GitHub Container Registry..."
echo "Masukkan GitHub Personal Access Token (scope: write:packages)"
echo "Buat di: https://github.com/settings/tokens/new?scopes=write:packages"
echo ""
docker login ghcr.io -u "${GITHUB_USER}"

# Build image
docker build \
    --build-arg KERYX_VERSION="${KERYX_VERSION}" \
    -t "${IMAGE_NAME}" \
    --platform linux/amd64 \
    .

# Push ke GHCR
echo "📤 Pushing to GHCR..."
docker push "${IMAGE_NAME}"

echo ""
echo "✅ Image pushed: ${IMAGE_NAME}"
echo ""

# ========================
# SALAD DEPLOYMENT CONFIG
# ========================
echo "============================================"
echo "  SALADCLOUD DEPLOYMENT CONFIG"
echo "============================================"
echo ""
echo "1. Login ke https://portal.salad.com"
echo "2. Buat Project baru (atau pakai yang ada)"
echo "3. Deploy Container Group dengan config ini:"
echo ""
echo "--- Container Group Config ---"
echo ""
cat << EOF
{
  "name": "keryx-miner",
  "containers": [
    {
      "image": "${IMAGE_NAME}",
      "command": ["/usr/local/bin/keryx-miner", "--mining-address", "${WALLET}"${MINING_FLAGS:+, "${MINING_FLAGS}"}],
      "environment_variables": [],
      "resources": {
        "cpu": 4,
        "memory": 4096,
        "storage": 10240
      }
    }
  ],
  "gpu_classes": [
    "NVIDIA RTX 4090",
    "NVIDIA RTX 4080",
    "NVIDIA RTX 4070 Ti",
    "NVIDIA RTX 3090",
    "NVIDIA RTX 3080",
    "NVIDIA RTX 3070 Ti"
  ],
  "replicas": 1,
  "autoscaling": {
    "enabled": false
  }
}
EOF
echo ""
echo "--- End Config ---"
echo ""
echo "GPU Classes yang didukung Keryx:"
echo "  - RTX 30xx (Ampere): CUDA compute cap 86"
echo "  - RTX 40xx (Ada Lovelace): CUDA compute cap 89"
echo "  - RTX 50xx (Blackwell): CUDA compute cap 100"
echo ""
echo "Estimated cost:"
echo "  - RTX 4090: ~\$0.18-0.25/hr"
echo "  - RTX 4070 Ti: ~\$0.08-0.12/hr"
echo "  - RTX 3070 Ti: ~\$0.04-0.06/hr"
echo ""
echo "Mining address: ${WALLET}"
echo "Mode: ${MINING_FLAGS:-default (PoW + OPoI)}"
echo ""
echo "============================================"
echo "  DONE! Deploy di Salad portal sekarang."
echo "============================================"
