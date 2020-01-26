resource "aws_api_gateway_method" "updog_link_site_page_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.updog_link.id}"
  resource_id   = "${aws_api_gateway_rest_api.updog_link.root_resource_id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "updog_link_site_page_redirect" {
  rest_api_id = "${aws_api_gateway_rest_api.updog_link.id}"
  resource_id = "${aws_api_gateway_rest_api.updog_link.root_resource_id}"
  http_method = "${aws_api_gateway_method.updog_link_site_page_get.http_method}"

  type                    = "MOCK"

  request_templates = "${local.simple_request_passthrough_template}"
}

resource "aws_api_gateway_method_response" "updog_link_site_redirect_get_response_302" {
  rest_api_id = "${aws_api_gateway_rest_api.updog_link.id}"
  resource_id = "${aws_api_gateway_rest_api.updog_link.root_resource_id}"
  http_method = "${aws_api_gateway_method.updog_link_site_page_get.http_method}"
  status_code = "302"

  response_models     = { "text/html" = "Empty" }

  response_parameters = { 
    "method.response.header.Location" = true,
    "method.response.header.Content-Type" = true 
  }
}

resource "aws_api_gateway_integration_response" "updog_link_site_redirect_200" {
  rest_api_id = "${aws_api_gateway_rest_api.updog_link.id}"
  resource_id = "${aws_api_gateway_rest_api.updog_link.root_resource_id}"
  http_method = "${aws_api_gateway_method.updog_link_site_page_get.http_method}"
  status_code = "${aws_api_gateway_method_response.updog_link_site_redirect_get_response_302.status_code}"

  selection_pattern = "-"

  response_parameters = { 
    "method.response.header.Location" = "'https://sover02.github.io/updog.link/'",
    "method.response.header.Content-Type" = "'text/html'"
  }

  response_templates = "${local.simple_response_passthrough_template}"
}

