resource "aws_s3_bucket_acl" "example" {
  count = var.enable_acl ? 1 : 0
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}