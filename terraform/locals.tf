locals {

  github_user = "sover02"
  github_repository = "sover02/updog.link"
  route53_domain    = "updog.link"
  route53_site_subdomain = "whats"

  request_template = {
    "application/json" = <<EOF
{
    "TableName": "updog_link_shortener",
    "IndexName": "shortlink-domain-index",
    "KeyConditionExpression": "shortlink = :v1",
    "ExpressionAttributeValues": {
        ":v1": {
            "S": "$input.params('shortlink')"
        }
    }
}
EOF
  }

  response_template = {
    "application/json" = <<EOF
$input.path('$').Items[0].destination.S
EOF
  }

}