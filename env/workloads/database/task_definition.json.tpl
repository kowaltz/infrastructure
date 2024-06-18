{
  "family": "zitadel",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "executionRoleArn": "${execution_role_arn}",
  "taskRoleArn": "${task_role_arn}",
  "containerDefinitions": [
    {
      "name": "zitadel",
      "image": "ghcr.io/zitadel/zitadel:latest",
      "command": ["start-from-init", "--masterkey", "MasterkeyNeedsToHave32Characters", "--tlsMode", "disabled"],
      "essential": true,
      "environment": [
        { "name": "ZITADEL_DATABASE_POSTGRES_HOST", "value": "db" },
        { "name": "ZITADEL_DATABASE_POSTGRES_PORT", "value": "5432" },
        { "name": "ZITADEL_DATABASE_POSTGRES_DATABASE", "value": "zitadel" },
        { "name": "ZITADEL_DATABASE_POSTGRES_USER_USERNAME", "value": "zitadel" },
        { "name": "ZITADEL_DATABASE_POSTGRES_USER_PASSWORD", "value": "zitadel" },
        { "name": "ZITADEL_DATABASE_POSTGRES_USER_SSL_MODE", "value": "disable" },
        { "name": "ZITADEL_DATABASE_POSTGRES_ADMIN_USERNAME", "value": "postgres" },
        { "name": "ZITADEL_DATABASE_POSTGRES_ADMIN_PASSWORD", "value": "postgres" },
        { "name": "ZITADEL_DATABASE_POSTGRES_ADMIN_SSL_MODE", "value": "disable" },
        { "name": "ZITADEL_EXTERNALSECURE", "value": "false" }
      ],
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080,
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/zitadel",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
