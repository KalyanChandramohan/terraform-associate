# GitHub Actions OIDC provider — lets workflows assume an AWS role without
# storing long-lived access keys. One provider per AWS account.
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # GitHub's OIDC root CA thumbprints (both current values for safety).
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
  ]
}

# Trust policy: only the configured repo may assume the role via OIDC.
data "aws_iam_policy_document" "github_actions_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repository}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions-terraform"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume.json
}

# Permissions the workflow gets after assuming the role.
# NOTE: AdministratorAccess is broad — scope this down to the IAM + state
# backend actions this config actually needs for production use.
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Use this value for the AWS_ROLE_ARN GitHub repo secret.
output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions.arn
  description = "ARN to set as the AWS_ROLE_ARN secret in GitHub Actions."
}
