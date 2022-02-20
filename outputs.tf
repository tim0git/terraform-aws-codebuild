output "aws_codebuild_project_name" {
  value       = aws_codebuild_project.this.name
  description = "The name of the CodeBuild project"
}
output "aws_codebuild_project_arn" {
  value       = aws_codebuild_project.this.arn
  description = "The ARN of the CodeBuild project"
}
output "aws_codebuild_project_environment" {
  value       = aws_codebuild_project.this.environment
  description = "The environment of the CodeBuild project"
}
output "aws_codebuild_project_source" {
  value       = aws_codebuild_project.this.source
  description = "The source of the CodeBuild project"
}
output "aws_codebuild_project_artifacts" {
  value       = aws_codebuild_project.this.artifacts
  description = "The artifacts of the CodeBuild project"
}
output "aws_codebuild_project_cache" {
  value       = aws_codebuild_project.this.cache
  description = "The cache of the CodeBuild project"
}
