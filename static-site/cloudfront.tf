locals {
  s3_origin_id = "${var.client}-${var.env_name}-origin"
}

resource aws_cloudfront_origin_access_control cloudfront_origin_access_control {
  name                              = aws_s3_bucket.frontend_cdn.bucket_regional_domain_name
  description                       = "${var.client}-${var.env_name}-access-control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource aws_s3_bucket_policy public_read_access {
  bucket = aws_s3_bucket.frontend_cdn.id
  policy = jsonencode(
     {
        "Version": "2008-10-17",
        "Id": "PolicyForCloudFrontPrivateContent",
        "Statement": [
            {
                "Sid": "AllowCloudFrontServicePrincipal",
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudfront.amazonaws.com"
                },
                "Action": "s3:GetObject",
                "Resource": "${aws_s3_bucket.frontend_cdn.arn}/*",
                "Condition": {
                    "StringEquals": {
                      "AWS:SourceArn": aws_cloudfront_distribution.s3_distribution.arn
                    }
                }
            }
        ]
      })
}

resource aws_cloudfront_distribution s3_distribution {
  origin {
    domain_name              = aws_s3_bucket.frontend_cdn.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_origin_access_control.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.client}-${var.env_name}-distribution"
  default_root_object = "index.html"

  aliases = ["${var.client}-${var.env_name}.${var.sub_domain}.${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
      acm_certificate_arn = "arn:aws:acm:us-east-1:883383164381:certificate/76731bab-8d19-414e-abc5-037ae0ea9c87"
      ssl_support_method = "sni-only"
      minimum_protocol_version = "TLSv1.2_2021"
  }
}