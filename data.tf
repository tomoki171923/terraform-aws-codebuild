data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

/*
    reading policy files in json format
*/
data "template_file" "codebuild_policy" {
  template = file("${path.module}/policies/codebuild_policy.json")
  vars = {
    aws_region         = data.aws_region.current.name
    aws_account        = data.aws_caller_identity.current.account_id
    build_project_name = var.build_project_name
  }
}
