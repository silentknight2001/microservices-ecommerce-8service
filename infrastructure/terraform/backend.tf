terraform {
  backend "s3" {
    bucket         = "ecommerce-devopsify-terraform-state"
    key            = "ecommerce/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "ecommerce-terraform-lock"
  }
}