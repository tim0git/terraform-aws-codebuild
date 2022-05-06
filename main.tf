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
    image                       = var.container_architecture == "arm64" ? "aws/codebuild/amazonlinux2-aarch64-standard:2.0" : var.image
    type                        = var.container_architecture == "arm64" ? "ARM_CONTAINER" : var.image_type
    image_pull_credentials_type = var.image_pull_credentials_type
    privileged_mode = var.enable_container_features

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
    buildspec = var.buildspec
  }

  tags = var.tags
}