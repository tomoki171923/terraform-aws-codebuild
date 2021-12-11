# *********** Variables *********** #

/*
  Basic
*/
variable "build_project_name" {
  type        = string
  description = "Project's name."
}

variable "description" {
  type        = string
  default     = "codebuild project"
  description = "Short description of the project."
}

variable "build_timeout" {
  type        = number
  default     = 5
  description = "Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed."
}

variable "queued_timeout" {
  type        = number
  default     = 5
  description = "Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out."
}


/*
  Environment
*/
variable "environment_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "An array of strings that specify the compute types that are allowed for the batch build."
}

variable "environment_image" {
  type        = string
  default     = "aws/codebuild/standard:3.0"
  description = "Docker image to use for this build project. Valid values include Docker images provided by CodeBuild (e.g aws/codebuild/standard:2.0), Docker Hub images (e.g. hashicorp/terraform:latest), and full Docker repository URIs such as those for ECR (e.g. 137112412989.dkr.ecr.us-west-2.amazonaws.com/amazonlinux:latest)."
}

variable "environment_type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "Type of build environment to use for related builds."
}

variable "environment_image_pull_credentials_type" {
  type        = string
  default     = "CODEBUILD"
  description = "Type of credentials AWS CodeBuild uses to pull images in your build."
}

variable "environment_environment_variable" {
  type = list(
    object({
      name  = string,
      value = string,
      type  = string
    })
  )
  default     = []
  description = "environment variables"
}

/*
  Source
*/
variable "source_location" {
  type        = string
  default     = "https://github.com/tomoki171923/codebuild-sample.git"
  description = "Location of the source code."
}
variable "source_buildspec" {
  type        = string
  default     = "buildspec.yml"
  description = "Build specification path to use for this build project's related builds. default is './buildspec.yml'"
}

variable "source_git_clone_depth" {
  type        = number
  default     = 0 //Use 0 for a Full.
  description = "Truncate git history to this many commits. Use 0 for a Full checkout which you need to run commands like git branch --show-current."
}

/*
  Source Credential
*/
variable "credential_auth_type" {
  type        = string
  default     = "PERSONAL_ACCESS_TOKEN"
  description = "The type of authentication used to connect to a GitHub"
}
variable "credential_github_token" {
  type        = string
  description = "For GitHub, this is the personal access token."
}

/*
  IAM Role
*/
variable "build_role_arn" {
  type        = string
  default     = null
  description = "Optional. If it is not set, create new iam role for this build project. Amazon Resource Name (ARN) of the AWS Identity and Access Management (IAM) role that enables AWS CodeBuild to interact with dependent AWS services on behalf of the AWS account."
}

/*
  IAM Policy
*/
variable "build_policy_arns" {
  type        = list(string)
  default     = []
  description = "Amazon Resource Names (ARN) of the AWS Identity and Access Management (IAM) policy that are attached to Build IAM Role."
}

/*
  Tags
*/
variable "tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }
  description = "A map of tags to add to resources"
}

/*
  Github webhook
*/

variable "webhook_build_type" {
  type        = string
  default     = "BUILD"
  description = "The type of build this webhook will trigger. Valid values for this parameter are: BUILD, BUILD_BATCH."
}

variable "webhook_filter_group" {
  type = list(list(map(string)))
  default = [
    [
      {
        type    = "EVENT"
        pattern = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED, PULL_REQUEST_MERGED"
      }
    ],
    [
      {
        type    = "EVENT"
        pattern = "PUSH"
      },
      {
        type    = "HEAD_REF"
        pattern = "refs/heads/main"
      }
    ]
  ]
  description = "A webhook filter for the group. the reference : https://docs.aws.amazon.com/codebuild/latest/userguide/github-webhook.html."
}
