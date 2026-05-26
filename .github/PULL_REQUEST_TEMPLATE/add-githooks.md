Title: Add .githooks and enable core.hooksPath

Description:
This PR adds the .githooks folder (already in this branch) and enables git hooks path for the repository. The included hook (ensure-aws-config.sh) blocks commits that add plaintext AWS credentials or credentials/config files.

Changes:
- Adds .githooks/ensure-aws-config.sh
- Adds instructions to enable hooks

How to apply (maintainer):
1. Review and merge this PR.
2. Run on the repository maintainer machine or CI runner:
   git config core.hooksPath .githooks
3. To verify, run: git config core.hooksPath

Automated onboarding (optional):
Use this script to enable hooks across multiple local clones:

for repo in repos/*; do
  (cd "$repo" && git config core.hooksPath .githooks || true)
done

Notes:
- This does not force hooks on remote clones; each clone must enable core.hooksPath. Consider adding contributors docs or CI enforcement.
