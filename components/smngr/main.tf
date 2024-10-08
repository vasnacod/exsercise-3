resource "aws_secretsmanager_secret" "smanager" {
  name        = var.smname
  description = "${var.project_name}-smng-key"
}

resource "aws_secretsmanager_secret_version" "smanagerver" {
  secret_id     = aws_secretsmanager_secret.smanager.id
  secret_string = jsonencode({
    name     = var.red_db_name
    username = var.red_admin_username
    password = var.red_admin_password
  })
}