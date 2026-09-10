resource "aws_ecs_cluster" "ecs_cluster" {
  name = "threatmod-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


# Creating IAM role
resource "aws_iam_role" "ecs_iam_role" {
  name = "ecs_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# Attaching policy to the IAM role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# Task Definition
resource "aws_ecs_task_definition" "ecs_service" {
  family                   = "threatmod-service"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_iam_role.arn
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  container_definitions = jsonencode([
    {
      name      = "threatmod-container"
      image     = "446503125863.dkr.ecr.eu-west-2.amazonaws.com/threatmod:v7"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    },
  ])
}