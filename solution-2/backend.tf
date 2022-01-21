terraform {
  backend "s3" {
    bucket         = "sc-12345678910-some-team-prefix-3556jakdxdt"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "TerraformLocks"
    encrypt        = true
  }
}
