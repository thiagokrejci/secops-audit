#!/usr/bin/env bash
set -euo pipefail
OUT="detect-aws-credentials.json"
profiles=()
if [ -f "$HOME/.aws/credentials" ]; then
  while IFS= read -r line; do
    if [[ "$line" =~ ^\[(.*)\]$ ]]; then
      profiles+=("${BASH_REMATCH[1]}")
    fi
  done < "$HOME/.aws/credentials"
fi

creds_found=false
matches=()
if command -v rg >/dev/null 2>&1; then
  while IFS= read -r l; do matches+=("$l"); creds_found=true; done < <(rg --hidden --no-ignore -n "aws_access_key_id|AWS_SECRET_ACCESS_KEY|aws_session_token|aws_session_token" "$HOME/.aws" || true)
else
  while IFS= read -r l; do matches+=("$l"); creds_found=true; done < <(grep -RIn --binary-files=without-match -I -n -E "aws_access_key_id|AWS_SECRET_ACCESS_KEY|aws_session_token" "$HOME/.aws" 2>/dev/null || true)
fi

# detect temporary tokens by presence of aws_session_token or access keys starting with ASIA (temporary)
temporary_tokens=false
if [ -f "$HOME/.aws/credentials" ]; then
  if rg --hidden --no-ignore -n "aws_session_token|^\s*aws_session_token" "$HOME/.aws/credentials" >/dev/null 2>&1; then
    temporary_tokens=true
  fi
  if rg --hidden --no-ignore -n "aws_access_key_id\s*=\s*ASIA" "$HOME/.aws/credentials" >/dev/null 2>&1; then
    temporary_tokens=true
  fi
fi

jq -n --argjson profiles "$(printf '%s\n' "${profiles[@]}" | jq -R . | jq -s .)" \
  --arg creds_found "$creds_found" \
  --arg temporary_tokens "$temporary_tokens" \
  --argjson matches "$(printf '%s\n' "${matches[@]}" | jq -R . | jq -s .)" \
  '{profiles: $profiles, creds_found: ($creds_found|test("true")), temporary_tokens: ($temporary_tokens|test("true")), matches: $matches}' > "$OUT"

echo "Wrote $OUT (summary of ~/.aws)." 
