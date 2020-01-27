data "aws_region" "current" {}

resource "aws_api_gateway_rest_api" "updog_link" {
  name = "${local.route53_domain}-shortlink-service"
}

resource "aws_api_gateway_stage" "production" {
  stage_name    = "production"
  rest_api_id   = "${aws_api_gateway_rest_api.updog_link.id}"
  deployment_id = "${aws_api_gateway_deployment.updog_link.id}"
}

resource "aws_api_gateway_deployment" "updog_link" {
  rest_api_id = "${aws_api_gateway_rest_api.updog_link.id}"
  stage_name  = "production"
}

resource "aws_api_gateway_domain_name" "updog_link" {
  certificate_arn = "${aws_acm_certificate_validation.cert.certificate_arn}"
  domain_name     = "${local.route53_domain}"
}

resource "aws_api_gateway_base_path_mapping" "updog_link" {
  api_id      = "${aws_api_gateway_rest_api.updog_link.id}"
  stage_name  = "${aws_api_gateway_deployment.updog_link.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.updog_link.domain_name}"
}
