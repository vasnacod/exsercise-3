output "secret_arn" {
  value = aws_secretsmanager_secret.smanager.arn
}
output "secret_name" {
  value = aws_secretsmanager_secret.smanager.name
}
output "secret_id" {
  value = aws_secretsmanager_secret.smanager.id
}
output "secret_version_id" {
  value = aws_secretsmanager_secret_version.smanagerver.id
}