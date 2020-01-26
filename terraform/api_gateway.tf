data "aws_region" "current" {}

resource "aws_api_gateway_rest_api" "updog_link" {
  name = "${local.route53_domain}-shortlink-service"
}

resource "aws_api_gateway_deployment" "updog_link" {
  depends_on = [
    "aws_api_gateway_integration.updog_shortlink_redirect_dynamo_query",
    ]

  rest_api_id = "${aws_api_gateway_rest_api.updog_link.id}"
  stage_name  = "production"

}
