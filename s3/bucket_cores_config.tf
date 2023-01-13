resource "aws_s3_bucket_cors_configuration" "example" {
  count  = var.enable_cores_config ? 1 : 0
  bucket = aws_s3_bucket.b.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://s3-website-test.hashicorp.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}