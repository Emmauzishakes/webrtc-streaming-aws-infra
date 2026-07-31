resource "aws_iam_policy" "terraform_deployment_policy" {
  name        = "Terraform-WebRTC-Deployment-Policy"
  description = "Allows Terraform to manage WebRTC infrastructure"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "elasticloadbalancing:*",
          "cloudwatch:*",
          "logs:*",
          "ssm:*",

          "iam:GetRole",
          "iam:PassRole",
          "iam:ListRoles",

          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DescribeRegions",
          "ec2:DescribeAvailabilityZones",

          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group" "terraform_deployers" {
  name = var.terraform_group_name
}

resource "aws_iam_group_policy_attachment" "attach_policy" {
  group      = aws_iam_group.terraform_deployers.name
  policy_arn = aws_iam_policy.terraform_deployment_policy.arn
}

resource "aws_iam_user" "terraform_user" {
  name = var.terraform_user_name
}

resource "aws_iam_user_group_membership" "terraform_membership" {
  user = aws_iam_user.terraform_user.name
  groups = [
    aws_iam_group.terraform_deployers.name
  ]
}

resource "aws_iam_access_key" "terraform_user_keys" {
  user = aws_iam_user.terraform_user.name
}
