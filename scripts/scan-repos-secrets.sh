#!/usr/bin/env bash
set -euo pipefail
OUT_DIR="reports"
mkdir -p "$OUT_DIR"
TS=$(date -u +%Y%m%dT%H%M%SZ)
if command -v gitleaks >/dev/null 2>&1; then
  gitleaks detect --source . --report-path "$OUT_DIR/gitleaks-$TS.json" || true
else
  echo "gitleaks not installed; skipping gitleaks" > "$OUT_DIR/gitleaks-$TS.txt"
fi

# scan for aws patterns in .terragrunt-cache
if command -v rg >/dev/null 2>&1; then
  rg --hidden --no-ignore -n --glob '**/.terragrunt-cache/**' "aws_access_key_id|AWS_SECRET_ACCESS_KEY|arn:aws:|sts:AssumeRole" || true
fi

echo "Secret scan completed. Reports in $OUT_DIR/" 
