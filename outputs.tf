output "iam" {
  value = {
    policy = module.codebuild_policy
    role   = module.codebuild_role
  }
}

output "project" {
  value = aws_codebuild_project.this
}

output "credential" {
  value     = aws_codebuild_source_credential.this
  sensitive = true
}

output "webhook" {
  value = aws_codebuild_webhook.this
}

output "ssm" {
  value     = aws_ssm_parameter.this
  sensitive = true
}
