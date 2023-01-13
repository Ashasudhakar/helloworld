module "s3" {
  source              = "./s3"
  enable_acl          = var.enable_acl
  enable_lifecycle    = var.enable_lifecycle
  enable_cores_config = var.enable_cores_config
  bucket_name         = var.bucket_name
}