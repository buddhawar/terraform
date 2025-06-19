terraform {
  backend "s3" {
    bucket = "tfs3backend-test"
    key    = "vpc"
    region = "us-east-1"
  }
}