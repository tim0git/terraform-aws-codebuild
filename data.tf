locals {
  ecr_image_repo_arn = var.enable_container_features ? format("arn:aws:ecr:%s:%s:repository/%s",
    var.environment_variables[index(var.environment_variables.*.name, "AWS_DEFAULT_REGION")].value,
    var.environment_variables[index(var.environment_variables.*.name, "AWS_ACCOUNT_ID")].value,
    var.environment_variables[index(var.environment_variables.*.name, "IMAGE_REPO_NAME")].value
  ) : ""
  ecr_policy = var.enable_container_features ? [{
    Effect : "Allow",
    Resource : [local.ecr_image_repo_arn],
    Action : [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
  },{
    Effect : "Allow",
    Resource : ["*"],
    Action : [
      "ecr:GetAuthorizationToken"
    ]
  }] : []
}

data "aws_caller_identity" "current" {}

data "aws_kms_key" "codedbuild_service_role_kms_key" {
  key_id = var.codedbuild_service_role_kms_key_alias
}

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
    Statement = concat([
      {
        Effect : "Allow",
        Resource : [
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:*:log-stream:/aws/codebuild/*",
          "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*"
        ],
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        Effect : "Allow",
        Action : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource : [
          "*"
        ]
      },
      {
        Effect : "Allow",
        Action : [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
        Resource : [
          "arn:aws:codebuild:*:${data.aws_caller_identity.current.account_id}:report-group/*"
        ]
      },
      {
        Effect : "Allow",
        Action : [
          "ssm:GetParameters",
        ],
        Resource : [
          "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"
        ]
      },
      {
        Effect : "Allow",
        Action : [
          "kms:GenerateDataKey",
        ],
        Resource : [
          data.aws_kms_key.codedbuild_service_role_kms_key.arn
        ]
      }
    ], local.ecr_policy)
  })
}