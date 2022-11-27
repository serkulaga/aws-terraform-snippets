### routre 53 
data aws_route53_zone  current {
  name         = "${var.domain}."
  private_zone = false
}

resource aws_route53_record frontend {
  zone_id = data.aws_route53_zone.current.zone_id
  name    = "${var.client}-${var.env_name}.${var.sub_domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}