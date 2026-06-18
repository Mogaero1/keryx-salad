#!/bin/bash
# Keryx Miner with automatic peer fallback
# Rotates through known peers if connection fails

MINER="/usr/local/bin/keryx-miner"
ADDRESS="keryx:qz8x35t7fzf97s09vyy2puyqx370wxc2m6pmq7vxvputm5t5v5w7uf826gsr9"
FLAGS="--high"

# Peer list: IP, sorted by latency (fastest first)
PEERS=(
  "185.245.61.83"    # ~163ms
  "62.60.148.215"    # ~177ms
  "165.22.93.184"    # ~184ms
  "217.182.199.65"   # ~245ms
  "90.11.201.149"    # ~257ms
)

# Peer health: consecutive failure count
declare -A FAIL_COUNT
for p in "${PEERS[@]}"; do FAIL_COUNT[$p]=0; done

MAX_FAILURES=3  # switch peer after N consecutive failures
current=0

echo "[entrypoint] Keryx miner starting with ${#PEERS[@]} peers"

while true; do
  peer="${PEERS[$current]}"
  echo "[entrypoint] Connecting to peer: $peer (attempt ${FAIL_COUNT[$peer]})"
  
  # Run miner - it will reconnect on its own, but if it crashes we rotate
  $MINER \
    --mining-address "$ADDRESS" \
    -s "grpc://$peer:22110" \
    $FLAGS
  
  # Miner exited (crash or error)
  FAIL_COUNT[$peer]=$(( ${FAIL_COUNT[$peer]} + 1 ))
  echo "[entrypoint] Peer $peer exited (failures: ${FAIL_COUNT[$peer]})"
  
  # If too many failures on current peer, rotate to next
  if [ ${FAIL_COUNT[$peer]} -ge $MAX_FAILURES ]; then
    echo "[entrypoint] Peer $peer failed ${MAX_FAILURES}x — rotating"
    FAIL_COUNT[$peer]=0
    current=$(( (current + 1) % ${#PEERS[@]} ))
    echo "[entrypoint] Switching to peer: ${PEERS[$current]}"
    sleep 3
  else
    # Same peer, retry after short delay
    sleep 2
  fi
done
