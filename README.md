secops-audit

Purpose: central repo of scripts and CI templates to continuously audit AWS infra, validate Terraform, detect credentials and standardize AWS profiles.

Quickstart:
- Copy this repo into your organization or use as template.
- Install required tools: gitleaks, terraform, tflint, tfsec, checkov, rg (ripgrep), awscli.
- Add secrets: SLACK_WEBHOOK, AWS_ROLE_TO_DISABLE (if auto-remediation used).
- Enable scheduled workflows in .github/workflows.
