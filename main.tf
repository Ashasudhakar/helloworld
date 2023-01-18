module "common" {
  source = "git::https://github.com/Ashasudhakar/terraform_modules.git//${var.module_name}?ref=${var.git_branch}"

  ################################################
  #           s3 features flag                   #
  ################################################
  enable_acl          = var.enable_acl
  enable_lifecycle    = var.enable_lifecycle
  enable_cores_config = var.enable_cores_config

  ################################################
  #           s3 general config                  #
  ################################################
  bucket_name         = var.bucket_name
}