data "aws_region" "current" {}

resource "aws_api_gateway_rest_api" "updog_link" {
  name = "updog.link"
}

resource "aws_api_gateway_resource" "updog_link_root" {
  rest_api_id = "${aws_api_gateway_rest_api.updog_link.id}"
  parent_id   = "${aws_api_gateway_rest_api.updog_link.root_resource_id}"
  path_part   = "{shortlink}"
}

resource "aws_api_gateway_method" "updog_link_root_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.updog_link.id}"
  resource_id   = "${aws_api_gateway_resource.updog_link_root.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "updog_shortlink_dynamo_query" {
  rest_api_id = "${aws_api_gateway_rest_api.updog_link.id}"
  resource_id = "${aws_api_gateway_resource.updog_link_root.id}"
  http_method = "${aws_api_gateway_method.updog_link_root_get.http_method}"

  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:dynamodb:action/Query"
  integration_http_method = "POST"
  credentials             = "${aws_iam_role.updog_link.arn}"

  passthrough_behavior = "NEVER"
  request_templates    = "${local.request_template}"
}

resource "aws_api_gateway_integration_response" "updog_link_root_200" {
  rest_api_id = "${aws_api_gateway_rest_api.updog_link.id}"
  resource_id = "${aws_api_gateway_resource.updog_link_root.id}"
  http_method = "${aws_api_gateway_method.updog_link_root_get.http_method}"
  status_code = "${aws_api_gateway_method_response.updog_link_root_get_response_302.status_code}"

  selection_pattern = "200"
  content_handling  = "CONVERT_TO_TEXT"

  response_parameters = { "method.response.header.Location" = "integration.response.body.Items[0].destination.S" }
  response_templates  = "${local.response_template}"
}

resource "aws_api_gateway_integration_response" "updog_link_root_500" {
  rest_api_id = "${aws_api_gateway_rest_api.updog_link.id}"
  resource_id = "${aws_api_gateway_resource.updog_link_root.id}"
  http_method = "${aws_api_gateway_method.updog_link_root_get.http_method}"
  status_code = "${aws_api_gateway_method_response.updog_link_root_get_response_404.status_code}"

  selection_pattern = "500"
}



resource "aws_api_gateway_method_response" "updog_link_root_get_response_302" {
  rest_api_id = "${aws_api_gateway_rest_api.updog_link.id}"
  resource_id = "${aws_api_gateway_resource.updog_link_root.id}"
  http_method = "${aws_api_gateway_method.updog_link_root_get.http_method}"
  status_code = "302"

  response_parameters = { "method.response.header.Location" = true }
  response_models     = { "application/json" = "Empty" }
}

resource "aws_api_gateway_method_response" "updog_link_root_get_response_404" {
  rest_api_id = "${aws_api_gateway_rest_api.updog_link.id}"
  resource_id = "${aws_api_gateway_resource.updog_link_root.id}"
  http_method = "${aws_api_gateway_method.updog_link_root_get.http_method}"
  status_code = "404"

  response_models = { "application/json" = "Error" }
}