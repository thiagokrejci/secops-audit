<h1 align="center">🛡️ SecOps Audit</h1>
<p align="center">Auditoria contínua de segurança em nuvem AWS — detecção de credenciais, validação de Terraform e hardening, via GitHub Actions.</p>

<p align="center">
  <img src="https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazonwebservices&logoColor=white"/>
  <img src="https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white"/>
  <img src="https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat&logo=githubactions&logoColor=white"/>
  <img src="https://img.shields.io/badge/Shell-4EAA25?style=flat&logo=gnubash&logoColor=white"/>
  <img src="https://img.shields.io/badge/DevSecOps-FF6B6B?style=flat"/>
  <a href="https://github.com/marketplace/actions/secops-audit"><img src="https://img.shields.io/badge/GitHub_Marketplace-Action-2088FF?style=flat&logo=githubactions&logoColor=white"/></a>
</p>

---

## ⚡ Use como GitHub Action

Adicione o scan de segredos (gitleaks) e a validação de Terraform a **qualquer** pipeline em poucas linhas:

```yaml
# .github/workflows/security.yml
name: Security
on: [push, pull_request]

jobs:
  secops:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0          # gitleaks varre todo o histórico
      - uses: thiagokrejci/secops-audit@v1
        with:
          scan-secrets: 'true'
          terraform-dir: 'infra'  # opcional; vazio = pula Terraform
          fail-on-findings: 'true'
```

### Inputs

| Input | Default | Descrição |
|-------|---------|-----------|
| `scan-secrets` | `true` | Roda o gitleaks no repositório. |
| `gitleaks-version` | `8.18.4` | Versão do gitleaks a instalar. |
| `terraform-dir` | `''` | Pasta com código Terraform (`fmt`/`validate`/`tfsec`). Vazio = pula. |
| `run-tfsec` | `true` | Roda análise estática tfsec no `terraform-dir`. |
| `fail-on-findings` | `false` | Falha o job se houver segredo detectado. |

### Outputs

| Output | Descrição |
|--------|-----------|
| `secrets-found` | `true` se o gitleaks achou segredo. |
| `secrets-count` | Quantidade de achados. |
| `report-dir` | Pasta com os relatórios JSON (`secops-reports/`). |

---

## 📌 Visão geral

Repositório central de **scripts e pipelines de CI** para auditar continuamente a infraestrutura AWS,
validar código Terraform, detectar credenciais expostas e padronizar perfis AWS. Pensado para rodar
de forma **automatizada e agendada**, aplicando práticas de **DevSecOps e shift-left security**.

## ⚙️ Pipelines automatizados (GitHub Actions)

| Workflow | Gatilho | O que faz |
|----------|---------|-----------|
| **AWS Credentials Monitor** | a cada hora | Monitora e detecta chaves de acesso AWS ativas/expostas |
| **Scheduled Audit** | a cada 6 horas | Varredura de segredos nos repositórios (gitleaks) e relatórios |
| **Terraform Validate** | em cada Pull Request `.tf` | Valida, lint e analisa segurança do IaC antes do merge |

## 🔧 Scripts

- **`detect-aws-credentials.sh`** — varre `~/.aws/credentials`, lista perfis e gera relatório JSON.
- **`disable-access-key.sh`** — desativa uma chave de acesso AWS comprometida (remediação).
- **`ensure-aws-config.sh`** — *pre-commit hook* que bloqueia commit com credenciais/arquivos sensíveis.
- **`scan-repos-secrets.sh`** — detecção de segredos com **gitleaks**, com relatórios datados.
- **`tf-validate-wrapper.sh`** — roda `terraform validate`, `tflint`, `tfsec` e `checkov` no IaC.

## 🚀 Como usar

```bash
# 1. Use este repositório como template na sua organização
# 2. Instale as ferramentas necessárias:
#    gitleaks, terraform, tflint, tfsec, checkov, ripgrep (rg), awscli
# 3. Configure os secrets no GitHub:
#    SLACK_WEBHOOK, AWS_ROLE_TO_DISABLE (se usar auto-remediação)
# 4. Ative os workflows agendados em .github/workflows
```

## 🧰 Stack de segurança

`gitleaks` · `tfsec` · `checkov` · `tflint` · `terraform` · `awscli` · `ripgrep`

---

<p align="center"><sub>Autoria: Thiago Krejci — Engenheiro SRE / DevOps / Cloud</sub></p>
