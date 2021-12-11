module "codebuild_policy" {
  count = var.build_role_arn == null ? 1 : 0
  # remote module
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "coudebuild_base_policy_${var.build_project_name}_${data.aws_region.current.name}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = data.template_file.codebuild_policy.rendered
  tags   = var.tags
}

module "codebuild_role" {
  count = var.build_role_arn == null ? 1 : 0
  # remote module
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_services = [
    "codebuild.amazonaws.com"
  ]
  create_role       = true
  role_name         = "CodebuildExecute_${var.build_project_name}_${data.aws_region.current.name}"
  role_description  = "CodeBuild Execute Role for ${var.build_project_name} Project in ${data.aws_region.current.name} region."
  role_requires_mfa = false

  custom_role_policy_arns = concat([module.codebuild_policy[0].arn], var.build_policy_arns)
  tags                    = var.tags
}
