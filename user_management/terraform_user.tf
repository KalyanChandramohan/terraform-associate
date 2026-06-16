resource "aws_iam_user" "user" {
  name = var.user_name
  path = "/"
  tags = {
    "Name" = var.user_name
  }

}

resource "aws_iam_policy_attachment" "admin_policy_attachment" {
  name       = "${var.user_name}-admin-policy-attachment"
  users      = [aws_iam_user.user.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

}

resource "aws_iam_access_key" "user_key" {
  user = aws_iam_user.user.name
}
