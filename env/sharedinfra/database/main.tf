provider "aws" {
  region = local.config.aws_region
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

data "aws_iam_policy_document" "ecs_task_execution_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_ecs_task_definition" "workload" {
  family       = "zitadel"
  network_mode = "bridge"
  # network_mode "awsvpc" attaches an ENI to the task
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256" # Adjust as needed
  memory                   = "512" # Adjust as needed
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = templatefile("${path.module}/task_definition.json.tpl", {
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    task_role_arn      = aws_iam_role.ecs_task_role.arn
    region             = var.aws_region
  })
}

resource "aws_ecs_service" "workload" {
  name            = "zitadel"
  cluster         = aws_ecs_cluster.workload.id
  task_definition = aws_ecs_task_definition.workload.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-12345678"] # Replace with your subnet IDs
    security_groups  = ["sg-12345678"]     # Replace with your security group IDs
    assign_public_ip = true
  }
}

resource "aws_ecs_cluster" "workload" {
  name = "zitadel"
}
