variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "my-code-build"
}

variable "build_timeout" {
  description = "The timeout for the build"
  type        = number
  default     = 60
}

variable "compute_type" {
  description = "Information about the compute resources the build project will use. Valid values: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, BUILD_GENERAL1_2XLARGE. BUILD_GENERAL1_SMALL is only valid if type is set to LINUX_CONTAINER. When type is set to LINUX_GPU_CONTAINER, compute_type must be BUILD_GENERAL1_LARGE"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "image" {
  description = "The name of the image"
  type        = string
  default     = "aws/codebuild/standard:5.0"
}

variable "image_type" {
  description = "Type of build environment to use for related builds. Valid values: LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_SERVER_2019_CONTAINER, ARM_CONTAINER"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "image_pull_credentials_type" {
  description = "Type of credentials AWS CodeBuild uses to pull images in your build. Valid values: CODEBUILD, SERVICE_ROLE. When you use a cross-account or private registry image, you must use SERVICE_ROLE credentials. When you use an AWS CodeBuild curated image, you must use CodeBuild credentials. Defaults to CODEBUILD"
  type        = string
  default     = "CODEBUILD"
}

variable "source_type" {
  description = "Type of repository that contains the source code to be built. Valid values: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET, S3, NO_SOURCE"
  type        = string
  default     = "CODEPIPELINE"
}

variable "buildspec" {
  description = "The buildspec file to use for the build"
  type        = string
  default     = "buildspec.yml"
}

variable "environment_variables" {
  description = "The environment variables"
  type        = any
  default = [
    {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
      type  = "PLAINTEXT"
    },
    {
      name  = "SOME_KEY2"
      value = "SOME_VALUE2"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "SOME_KEY3"
      value = "SOME_VALUE3"
      type  = "SECRETS_MANAGER"
    }
  ]
}

variable "enable_container_features" {
  description = "If true, build project will run in privileged mode, and ecr actions required for build and deploy will be added to build project iam role"
  type        = bool
  default     = false
}

variable "container_architecture" {
  description = "The container architecture. Valid values: amd64, arm64. Defaults to amd64"
  type        = string
  default     = "amd64"
}

variable "artifacts_type" {
  description = "Build output artifact's type. Valid values: CODEPIPELINE, NO_ARTIFACTS, S3"
  type        = string
  default     = "CODEPIPELINE"
}

variable "tags" {
  default = {
    Name = "my-code-build"
  }
  type        = map(string)
  description = "(Optional) Map of key-value resource tags to associate with the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
}