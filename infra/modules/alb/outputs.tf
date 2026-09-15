output "alb_dns_name" {
  value = aws_lb.ecs_alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.ecs_alb.zone_id
}

# output "alb_listener" {
#   value = aws_lb_listener.alb_listener
# }

output "ecs_target_group_arn" {
  value = aws_lb_target_group.ecs_target_group.arn
}