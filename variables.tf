# Flags for s3 related resources
variable "enable_acl" {}
variable "enable_lifecycle" {}
variable "enable_cores_config" {}

# Inputs for s3 bucket config
variable "bucket_name" {}

# Flags for ec2 related resources
variable "enable_eip" {}
# Inputs for ec2 resources config
variable "instance_name" {}
variable "instance_type" {}

# common
variable "enable_s3" {
  default = false
}
variable "enable_ec2" {
  default = false
}