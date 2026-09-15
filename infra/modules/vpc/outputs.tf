output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "subnet_A_ID" {
  value = aws_subnet.subnetA.id
}

output "subnet_B_ID" {
  value = aws_subnet.subnetB.id
}

output "ecs_vpc_ID" {
  value = aws_vpc.ecs-vpc.id
}


output "ecs_sg_ID" {
  value = aws_security_group.ecs_sg.id
}


