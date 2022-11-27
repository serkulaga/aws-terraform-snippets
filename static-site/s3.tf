resource aws_s3_bucket frontend_cdn {
  bucket = "${var.client}-${var.env_name}-frontend-cdn"
}

resource aws_s3_bucket_acl frontend_cdn {
  bucket = aws_s3_bucket.frontend_cdn.id
  acl    = "private"
}

resource aws_s3_bucket_public_access_block website_bucket_public_access_block {
  bucket                  = aws_s3_bucket.frontend_cdn.id
  ignore_public_acls      = true
  block_public_acls       = true
  restrict_public_buckets = true
  block_public_policy     = true
}

resource aws_s3_bucket_ownership_controls meta_frontend_cnd_resources {
  bucket = aws_s3_bucket.frontend_cdn.bucket
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}