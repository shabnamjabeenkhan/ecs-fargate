# Creating ECS Service
resource "aws_ecs_service" "threatmod_service" {
  name            = "threatmod-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on      = [aws_lb_listener.alb_listener]

  network_configuration {
    subnets = [
      aws_subnet.subnetA.id,
      aws_subnet.subnetB.id
    ]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }


  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "threatmod-container"
    container_port   = 8080
  }

}