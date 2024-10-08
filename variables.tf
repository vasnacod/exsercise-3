variable "aws_profile" {}
variable "region" {}
variable "project_name" {}
variable "accountid" {}

variable "dynamotfstate" {}
variable "s3tfstate" {}
variable "s3key" {}


variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "azzonea" {}
variable "azzoneb" {}

variable "smname" {}

variable "red_cluster_ident" {}
variable "red_db_name" {}
variable "red_admin_username" {
  sensitive = true
}
variable "red_admin_password" {
  sensitive = true
}
variable "red_node_type" {}
variable "red_cluster_type" {}
variable "red_numnodes" {}
variable "red_public" {}
variable "red_encrypted" {}
