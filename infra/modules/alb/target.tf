# Create Target Group
resource "aws_lb_target_group" "ecs_target_group" {
  name        = "ecs-target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.ecs-vpc.id
  health_check {
    path     = "/"
    protocol = "HTTP"
    port     = "traffic-port"
    matcher  = "200"
  }
}

