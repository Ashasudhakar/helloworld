terraform {
  backend "s3" {
    bucket = "demo-test0987-jenki"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
