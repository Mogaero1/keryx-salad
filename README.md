# Keryx Miner on SaladCloud — Deployment Guide

## Overview
Keryx Miner (v0.3.2-OPoI)部署到SaladCloud GPU mining。
- **Algorithm**: kHeavyHash (PoW) + OPoI (AI Inference)
- **GPU**: NVIDIA RTX 30xx/40xx/50xx
- **Wallet**: `keryx:qz8x35t7fzf97s09vyy2puyqx370wxc2m6pmq7vxvputm5t5v5w7uf826gsr9`

## Quick Start (5 Minutes)

### Step 1: Create GitHub Repo
1. Go to https://github.com/new
2. Name: `keryx-salad`
3. Upload these files:
   - `Dockerfile`
   - `.github/workflows/build-keryx.yml`

### Step 2: Enable GitHub Actions
1. Go to repo → Actions tab
2. Click "I understand my workflows, go ahead and enable them"
3. Click "Run workflow" → "Run workflow"
4. Wait 5-10 minutes for build to complete

### Step 3: Get GHCR Image URL
After build completes, your image will be at:
```
ghcr.io/YOUR_USERNAME/keryx-salad/keryx-miner:latest
```

### Step 4: Deploy on SaladCloud
1. Login to https://portal.salad.com
2. Click "New Container Group"
3. Fill in:
   - **Name**: `keryx-miner`
   - **Image**: `ghcr.io/YOUR_USERNAME/keryx-salad/keryx-miner:latest`
   - **Command**: 
     ```
     /usr/local/bin/keryx-miner --mining-address keryx:qz8x35t7fzf97s09vyy2puyqx370wxc2m6pmq7vxvputm5t5v5w7uf826gsr9
     ```
   - **GPU Class**: Select "NVIDIA RTX 4070 Ti" or higher
   - **Replicas**: 1 (start with 1, scale up later)
4. Click "Deploy"

### Step 5: Monitor
- Check SaladCloud dashboard for GPU utilization
- Check Keryx dashboard at https://keryx-labs.com/wallet

## Configuration Options

### Mining Modes
| Mode | Flag | VRAM | Rewards |
|------|------|------|---------|
| PoW Only | `--no-opoi` | <4GB | Base |
| Light | `--light` | 4GB+ | +10% |
| Default | (none) | 8GB+ | +25% |
| High | `--high` | 24GB+ | +40% |
| Very High | `--very-high` | 32GB+ | +60% |

### GPU Selection Guide
| GPU | VRAM | Mode | Est. Cost/hr |
|-----|------|------|--------------|
| RTX 3070 Ti | 8GB | Default | $0.04-0.06 |
| RTX 4070 Ti | 12GB | Default | $0.08-0.12 |
| RTX 3090 | 24GB | High | $0.12-0.18 |
| RTX 4090 | 24GB | High | $0.18-0.25 |

### Example Commands
```bash
# Default (PoW + OPoI)
/usr/local/bin/keryx-miner --mining-address keryx:YOUR_ADDRESS

# Light mode (4GB VRAM)
/usr/local/bin/keryx-miner --mining-address keryx:YOUR_ADDRESS --light

# PoW only (no inference)
/usr/local/bin/keryx-miner --mining-address keryx:YOUR_ADDRESS --no-opoi

# High mode (24GB VRAM)
/usr/local/bin/keryx-miner --mining-address keryx:YOUR_ADDRESS --high
```

## Troubleshooting

### Container Won't Start
- Check image name is correct
- Ensure GPU class is selected
- Check SaladCloud logs

### Mining Not Working
- Verify wallet address is correct
- Check SaladCloud balance
- Monitor GPU utilization

### Low Rewards
- Try higher mode (e.g., `--high` if VRAM allows)
- Scale up replicas
- Check network difficulty

## Cost Calculator
- **1 RTX 4070 Ti**: ~$0.10/hr = ~$2.40/day = ~$72/month
- **Expected mining**: Check https://keryx-labs.com/calculator
- **ROI**: Depends on KERYX price and network difficulty

## Support
- Discord: https://discord.gg/keryx
- GitHub: https://github.com/keryx-labs
