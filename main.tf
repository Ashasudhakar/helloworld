module "s3" {
  source           = "./s3"
  enable_acl       = var.enable_acl
  enable_lifecycle = var.enable_lifecycle
}