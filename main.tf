provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

/* module "tfstate" {
  source = "./tfstate/"
  dynamotfstate = var.dynamotfstate
  s3tfstate = var.s3tfstate  
} */

/* terraform {
  backend "s3" {
    bucket         = var.s3tfstate
    key            = var.s3key
    region         = var.region
    encrypt        = true
    dynamodb_table = var.dynamotfstate
  }
} */


