[
  {
    "name": "${container_name}",
    "image": "${image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": ${host_port},
        "protocol": "tcp",
        "appProtocol": "http"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-create-group": "true",
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "environment": [
      {
        "name": "DB_HOST",
        "value": "${db_host}"
      },
      {
        "name": "DB_NAME",
        "value": "${db_name}"
      },
      {
        "name": "DB_USERNAME",
        "value": "${db_user}"
      },
      {
        "name": "DB_PASSWORD",
        "value": "${db_password}"
      }
    ]
  }
]
