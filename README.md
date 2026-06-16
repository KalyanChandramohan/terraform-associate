# Terraform — IAM User Management

Terraform configuration that provisions an IAM user with `AdministratorAccess`
and an access key, deployed via GitHub Actions.

## Layout

```
.
├── .github/workflows/terraform.yml   # CI: plan on PR, apply on merge to main
├── .gitignore                        # excludes tfstate (contains secrets!)
└── user_management/
    ├── provider.tf
    ├── var.tf
    ├── terraform_user.tf
    ├── outputs.tf
    └── backend.tf.example            # rename + configure for remote state
```

## CI/CD flow

| Event                | Actions run                                  |
| -------------------- | -------------------------------------------- |
| Pull request to main | fmt check, init, validate, **plan**          |
| Push/merge to main   | the above, then **apply** (auto-approved)    |

Authentication to AWS uses **GitHub OIDC** — no long-lived AWS keys are stored
in GitHub.

## One-time setup

### 1. Create the AWS OIDC provider (once per account)

```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

### 2. Create an IAM role the workflow can assume

Trust policy (replace `ACCOUNT_ID`, `OWNER/REPO`):

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
    },
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": { "token.actions.githubusercontent.com:aud": "sts.amazonaws.com" },
      "StringLike": { "token.actions.githubusercontent.com:sub": "repo:OWNER/REPO:*" }
    }
  }]
}
```

Attach a permissions policy allowing the IAM + S3/DynamoDB (state) actions this
config needs. Note the role ARN.

### 3. Add the role ARN to the repo

GitHub → Settings → Secrets and variables → Actions → New repository secret:

- **Name:** `AWS_ROLE_ARN`
- **Value:** `arn:aws:iam::ACCOUNT_ID:role/your-gha-role`

### 4. Configure remote state (required for the apply job)

See [`user_management/backend.tf.example`](user_management/backend.tf.example).
Rename it to `backend.tf`, fill in your S3 bucket / DynamoDB table, then run:

```bash
cd user_management
terraform init -migrate-state
```

### 5. (Optional) Require approval before apply

The `apply` job uses a `production` environment. In GitHub → Settings →
Environments → `production`, add yourself as a **required reviewer** to gate
every apply behind manual approval.

## Security notes

- `terraform.tfstate` holds the IAM **secret key in plaintext** and is
  gitignored. Never commit it. Remote S3 state (encrypted) is the durable home.
- The `secret_key` output is marked `sensitive`; retrieve it locally with
  `terraform output -raw secret_key`.
