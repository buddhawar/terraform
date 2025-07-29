terraform {
  backend "s3" {
    bucket = "tfs3backend-test"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}