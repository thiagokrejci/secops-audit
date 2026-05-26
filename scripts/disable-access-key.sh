#!/usr/bin/env bash
set -euo pipefail
if [ -z "${AWS_ACCESS_KEY_ID_TO_DISABLE:-}" ]; then
  echo "Set AWS_ACCESS_KEY_ID_TO_DISABLE env var to the access key id to disable"; exit 2
fi
if ! command -v aws >/dev/null 2>&1; then
  echo "aws cli not found"; exit 1
fi
# This script requires AWS credentials with iam:UpdateAccessKey
aws iam update-access-key --access-key-id "$AWS_ACCESS_KEY_ID_TO_DISABLE" --status Inactive || { echo "Failed to disable key"; exit 3; }
echo "Disabled access key: $AWS_ACCESS_KEY_ID_TO_DISABLE"
