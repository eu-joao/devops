#!/usr/bin/env bash
# Compatibilidade: encaminha para o runtime novo.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$SCRIPT_DIR/../agents/runtime/run-agent.sh" "$@"
