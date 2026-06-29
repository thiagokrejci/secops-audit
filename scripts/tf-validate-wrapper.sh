#!/usr/bin/env bash
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

# Terraform checks
if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform not found"; exit 1
fi

terraform fmt -check -recursive || { echo "terraform fmt failed"; exit 2; }
terraform init -backend=false || { echo "terraform init failed"; exit 3; }
terraform validate || { echo "terraform validate failed"; exit 4; }

# plan each module (best-effort)
if terraform plan -no-color -out=tfplan 2>/dev/null; then
  echo "terraform plan created: tfplan"
else
  echo "terraform plan failed (may require backend config)"; true
fi

# lint and security
if command -v tflint >/dev/null 2>&1; then
  tflint || true
fi
if command -v tfsec >/dev/null 2>&1; then
  tfsec . || true
fi
if command -v checkov >/dev/null 2>&1; then
  checkov -d . || true
fi

echo "Terraform validation wrapper finished" 
