GH Actions Secrets & Integration (secops-audit)

Required secrets (set in repo or organization secrets):
- SLACK_WEBHOOK: webhook URL for alert notifications (format: https://hooks.slack.com/services/...) - used by scheduled-audit workflow.
- AWS_ROLE_TO_DISABLE (optional): ARN or role name used by remediation automation to assume permissions for disabling keys. Prefer using OIDC + short-lived role rather than storing long-lived credentials.
- AWS_REMOVAL_ROLE_SESSION_NAME: session name for role assumption (optional)
- GITHUB_TOKEN: default provided by Actions (no action needed). For cross-repo checkout, set a PAT with repo scope and store as ORG_PAT.

Permissions and runner setup:
- Scheduled audit should run in a runner with access to the checked-out repos or via gh CLI using an org PAT.
- For detect-aws-credentials job that inspects ~/.aws on self-hosted runners, ensure runners are secure and managed.
- Remediation actions (disable key) require iam:UpdateAccessKey and iam:ListAccessKeys. Use a dedicated role with least privilege and session tags/audit.

Best practices:
- Use GitHub Organization secrets where possible and restrict access to specific repositories/workflows.
- Prefer OIDC + assume-role for AWS access from workflows: avoid storing AWS credentials in GitHub secrets.
- Limit automated remediation to a small set of service accounts; require manual approval for production-scoped keys.

Integration notes:
- Slack notifications: post summary + artifact link, avoid posting secret details.
- Store reports in a secure S3 bucket (encrypted) and centralize findings with SNS/SQS for downstream processing.
