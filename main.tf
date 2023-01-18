module "s3" {
  count = var.enable_s3 ? 1 : 0
  # source = "git::https://github.com/Ashasudhakar/terraform_modules.git//var_module_name?ref=var_git_branch"
  source = "git::https://github.com/Ashasudhakar/terraform_modules.git//s3?ref=main"

  ################################################
  #           s3 features flag                   #
  ################################################
  enable_acl          = var.enable_acl
  enable_lifecycle    = var.enable_lifecycle
  enable_cores_config = var.enable_cores_config

  ################################################
  #           s3 general config                  #
  ################################################
  bucket_name = var.bucket_name
}

module "ec2" {
  count = var.enable_ec2 ? 1 : 0
  # source = "git::https://github.com/Ashasudhakar/terraform_modules.git//var_module_name?ref=var_git_branch"
  source = "git::https://github.com/Ashasudhakar/terraform_modules.git//ec2?ref=main"
  ################################################
  #           ec2 features flag                   #
  ################################################
  enable_eip = var.enable_eip

  ################################################
  #           ec2 general config                  #
  ################################################
  instance_name = var.instance_name
  instance_type = var.instance_type
}