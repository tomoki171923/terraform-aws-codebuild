resource "aws_ssm_parameter" "this" {
  name        = "/codebuild/${var.build_project_name}"
  description = "git hub token for codebuild ${var.build_project_name} project"
  type        = "SecureString"
  value       = var.credential_github_token
  overwrite   = true

  tags = var.tags
}
