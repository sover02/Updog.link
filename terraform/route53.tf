resource "aws_route53_zone" "updog_link" {
  name = "${local.route53_domain}"

  tags = {
    Name       = "updog_link_r53-dns-zone"
    managed-by = "terraform"
  }
}

resource "aws_route53_record" "updog_link" {
  name    = "${local.route53_domain}"
  type    = "A"
  zone_id = "${aws_route53_zone.updog_link.id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_api_gateway_domain_name.updog_link.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.updog_link.cloudfront_zone_id}"
  }
}

resource "aws_route53_record" "updog_link_site" {
  zone_id = "${aws_route53_zone.updog_link.zone_id}"
  name    = "${local.route53_site_subdomain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${local.github_user}.github.io"]
}

resource "aws_acm_certificate" "updog_link" {
  domain_name       = "${local.route53_domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.updog_link.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.updog_link.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_zone.updog_link.zone_id}"
  records = ["${aws_acm_certificate.updog_link.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${aws_acm_certificate.updog_link.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}
