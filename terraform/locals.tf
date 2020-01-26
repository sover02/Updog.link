locals {

  github_repository = {
    full_name = "sover02/updog.link"
  }

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