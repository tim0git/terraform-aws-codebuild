resource "aws_iam_role" "this" {
  name = "${var.project_name}-codebuild-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  managed_policy_arns = [aws_iam_policy.codebuild.arn]
}

resource "aws_iam_policy" "codebuild" {
  name = "${var.project_name}-codebuild-iam-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Resource": [
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:*:log-stream:/aws/codebuild/*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*"
        ],
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
        "Resource": [
          "arn:aws:codebuild:*:${data.aws_caller_identity.current.account_id}:report-group/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "ssm:GetParameters",
        ],
        "Resource": [
          "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"
        ]
      }
    ]
  })
}

resource "aws_codebuild_project" "this" {
  name          = "${var.project_name}-codebuild"
  description   = "${var.project_name}-codebuild-project"
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.this.arn

  artifacts {
    type = var.artifacts_type
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = var.image_type
    image_pull_credentials_type = var.image_pull_credentials_type


    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.project_name}"
      stream_name = "/aws/codebuild/${var.project_name}"
    }
  }

  source {
    type = var.source_type
  }

  tags = var.tags
}