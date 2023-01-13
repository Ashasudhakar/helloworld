resource "aws_s3_bucket_lifecycle_configuration" "example" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.b.id

  rule {
    id = "rule-1"

    filter {
      prefix = "logs/"
    }

    # ... other transition/expiration actions ...

    status = "Enabled"
  }
}