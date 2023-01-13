resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-093572"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}