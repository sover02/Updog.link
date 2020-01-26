provider "aws" {
  region = "us-east-1"
}

provider "archive" {}

terraform {
  backend "s3" {
    bucket = "updog.link-tf"
    key    = "updog.link-tf-main"
    region = "us-east-1"
  }

  required_version = "0.12.12"

}
