#!/usr/bin/env bash
# Pre-commit check: prevent committing plaintext AWS credentials or adding credentials files
if git diff --cached --name-only | rg -q "\.aws|credentials|config"; then
  echo "Commit includes AWS config/credentials file. Remove sensitive files before commit." >&2
  exit 1
fi
# scan staged files for credential-like patterns
if git diff --cached -U0 | rg -q "aws_access_key_id|AWS_SECRET_ACCESS_KEY|aws_session_token"; then
  echo "Staged changes contain AWS credential patterns. Remove them." >&2
  exit 1
fi
exit 0
