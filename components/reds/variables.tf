variable "project_name" {}
variable "red_cluster_ident" {}
variable "red_db_name"  {}
variable "red_admin_username"  {}
variable "red_admin_password"  {}
variable "red_node_type"  {}
variable "red_cluster_type"  {}
variable "red_numnodes"  {}
variable "red_public"  {}
variable "red_encrypted"  {}
variable "iam_roles_arn"  {}
//variable "secgrpid" {}
variable "secgrpid" {
  type        = list(string)
}
variable "redsubnetgrp"  {}
