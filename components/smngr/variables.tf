variable "red_db_name" {}
variable "red_admin_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}
variable "red_admin_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}
variable "project_name" {}
variable "smname" {}