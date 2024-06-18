locals {
  config = yamldecode(file(var.path_config_yaml))

  organization = local.config.organization

  db_instance_name = "${local.organization}-rds-sharedinfra_${var.env}-postgres"
}

resource "aws_db_subnet_group" "postgres" {
  name       = "education"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "Education"
  }
}

resource "aws_db_parameter_group" "postgres" {
  // Changing a parameter group always requires a reboot,
  // hence a custom one is specified.
  name   = "education"
  family = "postgres14"

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
  parameter_group_name  = "default.mysql8.0"
  port                  = 5432

  // Networking
  db_subnet_group_name =
  vpc_security_group_ids =

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