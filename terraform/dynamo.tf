resource "aws_dynamodb_table" "updog_link_shortener" {
  name         = "updog_link_shortener"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "shortlink"
  range_key    = "domain"

  attribute {
    name = "shortlink"
    type = "S"
  }

  attribute {
    name = "domain"
    type = "S"
  }

  tags = {
    Name      = "updog_link_shortener_dynamo_table"
    manged-by = "terraform"
    project   = "updog_link_shortener"
  }

  global_secondary_index {
    name            = "shortlink-domain-index"
    hash_key        = "shortlink"
    range_key       = "domain"
    projection_type = "ALL"
  }


}

resource "aws_dynamodb_table_item" "shortlink" {
  count      = "${length(local.shortlinks)}"
  table_name = "${aws_dynamodb_table.updog_link_shortener.name}"
  hash_key   = "${aws_dynamodb_table.updog_link_shortener.hash_key}"
  range_key  = "${aws_dynamodb_table.updog_link_shortener.range_key}"

  item = <<ITEM
{
  "shortlink": {"S": "${element(local.shortlinks[count.index], 0)}"},
  "domain": {"S": "${local.route53_domain}"},
  "destination": {"S": "${element(local.shortlinks[count.index], 1)}"}
}
ITEM
}