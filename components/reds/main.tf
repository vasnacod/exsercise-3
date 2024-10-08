data "aws_secretsmanager_secret" "smanager" {
 arn = var.secret_arn
}

data "aws_secretsmanager_secret_version" "smanagerver" {
  secret_id = data.aws_secretsmanager_secret.smanager.id
}

locals {
  secret_data = jsondecode(data.aws_secretsmanager_secret_version.smanagerver.secret_string)
}

resource "aws_redshift_cluster" "redshift-cluster" {
  cluster_identifier = var.red_cluster_ident
  database_name = local.secret_data["name"]
  master_username = local.secret_data["username"]
  master_password = local.secret_data["password"]
  node_type          = var.red_node_type
  cluster_type       = var.red_cluster_type
  vpc_security_group_ids = var.secgrpid
  publicly_accessible = var.red_public
  encrypted         = var.red_encrypted
  number_of_nodes    = var.red_numnodes

  iam_roles = [var.iam_roles_arn]

  cluster_subnet_group_name = var.redsubnetgrp
  
  skip_final_snapshot = true

  tags = {
    Name        = "${var.project_name}-redshift-cluster"
  }
 depends_on = [data.aws_secretsmanager_secret_version.smanagerver]
}

resource "aws_redshift_scheduled_action" "resume" {
  name     = "resume-redshift-cluster"
  schedule = "cron(0 8 ? * MON-FRI *)"
  iam_role = var.iam_roles_arn

  target_action {
    resume_cluster {
      cluster_identifier = aws_redshift_cluster.redshift-cluster.cluster_identifier
    }
  }
}

resource "aws_redshift_scheduled_action" "pause" {
  name     = "pause-redshift-cluster"
  schedule = "cron(0 17 ? * MON-FRI *)"
  iam_role = var.iam_roles_arn

  target_action {
    pause_cluster {
      cluster_identifier = aws_redshift_cluster.redshift-cluster.cluster_identifier
    }
  }
}