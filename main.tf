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

module "vpc" {
  source                 = "./components/vpc"
  project_name           = var.project_name
  vpc_cidr               = var.vpc_cidr
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
  public_subnet_az2_cidr = var.public_subnet_az2_cidr
  azzonea                = var.azzonea
  azzoneb                = var.azzoneb
  region                 = var.region
}

module "secretmanager" {
  source             = "./components/smngr"
  red_db_name        = var.red_db_name
  red_admin_username = var.red_admin_username
  red_admin_password = var.red_admin_password
  project_name       = var.project_name
  smname             = var.smname
}
output "smanger_name" {
  value = module.secretmanager.secret_name
} 
output "smanger_id" {
  value = module.secretmanager.secret_id
} 
module "redshift" {
  source             = "./components/reds"
  project_name       = var.project_name
  iam_roles_arn      = module.vpc.iam_roles_arn
  secgrpid           = module.vpc.secgrpid
  redsubnetgrp       = module.vpc.redsubnetgrp
  red_cluster_ident  = var.red_cluster_ident
  red_db_name        = var.red_db_name
  red_admin_username = var.red_admin_username
  red_admin_password = var.red_admin_password
  red_node_type      = var.red_node_type
  red_cluster_type   = var.red_cluster_type
  red_numnodes       = var.red_numnodes
  red_public         = var.red_public
  red_encrypted      = var.red_encrypted
  smname = var.smname
  secret_id         = module.secretmanager.secret_id
  secret_version_id = module.secretmanager.secret_version_id
  secret_arn = module.secretmanager.secret_arn
}
