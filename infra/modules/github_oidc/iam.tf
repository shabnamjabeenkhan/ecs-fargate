# Register GitHub as an OIDC identity provider
resource "aws_iam_openid_connect_provider" "github_actions_provider" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

}

# Creating IAM role
resource "aws_iam_role" "github_actions_iam_role" {
  name = "threatmod-github-actions-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions_provider.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:shabnamjabeenkhan@98359890/ecs-fargate@1343249014:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

# Giving the IAM role necessary permissions
resource "aws_iam_role_policy" "iam_role_permission" {
  name = "iam-role-permission"
  role = aws_iam_role.github_actions_iam_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [


      {
        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Effect   = "Allow"
        Resource = "*"
      },


      {
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Effect   = "Allow"
        Resource = var.ecs_repo_arn
      },
       {
        Action = [
          "ecs:RegisterTaskDefinition",
          "ecs:DeregisterTaskDefinition",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeServices",
          "ecs:UpdateService"
        ]

        Effect   = "Allow"
        Resource = "*"
      },
      {
  Action = [
    "iam:PassRole"
  ]

  Effect   = "Allow"
  Resource = var.ecs_role_arn
},
{
  Action = [
    "s3:ListBucket"
  ]

  Effect   = "Allow"
  Resource = "arn:aws:s3:::threatmod-terraform-state-446503125863"
},
{
  Action = [
    "s3:GetObject",
    "s3:PutObject",
    "s3:DeleteObject"
  ]

  Effect = "Allow"
  Resource = [
    "arn:aws:s3:::threatmod-terraform-state-446503125863/ecs-fargate/terraform.tfstate",
    "arn:aws:s3:::threatmod-terraform-state-446503125863/ecs-fargate/terraform.tfstate.tflock"
  ]
}
    ]
  })
}
