# Creating ECS Service
resource "aws_ecs_service" "threatmod_service" {
  name            = "threatmod-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_service.arn
  desired_count   = 0
  launch_type     = "FARGATE"
  # depends_on      = [var.alb_listener] 

  network_configuration {
    subnets = [
      var.subnet_A_ID,
      var.subnet_B_ID 
    ]
    security_groups  = [var.ecs_sg_ID] 
    assign_public_ip = true
  }


  load_balancer {
    target_group_arn = var.ecs_target_group_arn 
    container_name   = "threatmod-container"
    container_port   = 8080
  }
}