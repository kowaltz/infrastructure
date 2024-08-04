locals {
  config = yamldecode(file(var.path_config_yaml))

  organization = local.config.organization

  db_instance_name = "${local.organization}-rds-sharedinfra_${var.env}-postgres"
}

resource "aws_db_subnet_group" "postgres" {
  name       = var.env
  subnet_ids = [var.map_of_subnet_ids["sharedinfra_database"]]
}

resource "aws_db_parameter_group" "postgres" {
  // Changing a parameter group always requires a reboot,
  // hence a custom one is specified.
  name   = var.env
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage     = 1 #GB
  max_allocated_storage = 1
  db_name               = local.db_instance_name
  engine                = "postgres"
  engine_version        = "16.3"
  instance_class        = "db.t3.micro"
  parameter_group_name  = aws_db_parameter_group.postgres.name
  port                  = 5432

  // Networking
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [
    for sg in var.map_of_security_group_ids["sharedinfra_database"] : sg.id
  ]

  // Root user
  username                    = "sharedinfra_${var.env}_pg"
  manage_master_user_password = true

  // Maintenance
  auto_minor_version_upgrade = true
  blue_green_update { enabled = false }
  // backup_window = "09:46-10:16"
  delete_automated_backups = false
  deletion_protection      = true
  // maintenance_window = "Mon:00:00-Mon:03:00
  final_snapshot_identifier = "${local.db_instance_name}-${formatdate("YYYYMMDD", timestamp())}"
  skip_final_snapshot       = true
}