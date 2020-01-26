data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "updog_link" {
  statement {
    sid = "UpdogLinkDynamo"

    resources = [
      "${aws_dynamodb_table.updog_link_shortener.arn}",
      "${aws_dynamodb_table.updog_link_shortener.arn}/stream/*",
      "${aws_dynamodb_table.updog_link_shortener.arn}/index/*",
    ]

    actions = [
      "dynamodb:*",
    ]
  }
}

resource "aws_iam_policy" "updog_link" {
  name        = "updog_link"
  path        = "/updog_link/"
  description = "updog_link DynamoDB backend access"
  policy      = "${data.aws_iam_policy_document.updog_link.json}"
}

resource "aws_iam_role" "updog_link" {
  name = "updog_link_role"
  path = "/updog_link/"

  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}