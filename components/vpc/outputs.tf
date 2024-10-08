output "iam_roles_arn" {
  description = "iam role arn"
  value       = aws_iam_role.redshift-role.arn
}
output "secgrpid" {
  description = "security group id redshift"
  value       = [aws_default_security_group.redshift_security_group.id]
}
output "redsubnetgrp" {
  value = aws_redshift_subnet_group.redshift-subnet-group.name
}