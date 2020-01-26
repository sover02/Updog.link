locals {

  domains = {
    "updog.link" = "${aws_route53_record.updog_link.fqdn}"
  }

  shortlinks = [
    ["github", "updog.link", "https://github.com"],
    ["gmail", "updog.link", "https://gmail.com"],
  ]
}
