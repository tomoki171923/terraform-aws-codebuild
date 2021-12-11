# ********************************* #
# CodeBuild
# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project
#    : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential
# ********************************* #

resource "aws_codebuild_project" "this" {
  name           = var.build_project_name
  description    = var.description
  build_timeout  = var.build_timeout
  queued_timeout = var.queued_timeout

  service_role = var.build_role_arn == null ? module.codebuild_role[0].iam_role_arn : var.build_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = var.cache_type
    modes = var.cache_modes
  }

  environment {
    compute_type                = var.environment_compute_type
    image                       = var.environment_image
    type                        = var.environment_type
    image_pull_credentials_type = var.environment_image_pull_credentials_type

    dynamic "environment_variable" {
      for_each = var.environment_environment_variable
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  source {
    type            = "GITHUB"
    location        = var.source_location
    buildspec       = var.source_buildspec
    git_clone_depth = var.source_git_clone_depth
    git_submodules_config {
      fetch_submodules = true
    }
  }
  source_version = var.source_version

  tags = var.tags
}

resource "aws_codebuild_source_credential" "this" {
  server_type = "GITHUB"
  auth_type   = var.credential_auth_type
  token       = var.credential_github_token
}

resource "aws_codebuild_webhook" "this" {
  project_name = aws_codebuild_project.this.name
  build_type   = var.webhook_build_type

  /* e.g.
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }
    filter {
      type    = "HEAD_REF"
      pattern = "master"
    }
  }
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED, PULL_REQUEST_MERGED"
    }
  }
  */
  dynamic "filter_group" {
    for_each = var.webhook_filter_group
    content {
      dynamic "filter" {
        for_each = filter_group.value
        content {
          type    = filter.value.type
          pattern = filter.value.pattern
        }
      }
    }
  }
}
