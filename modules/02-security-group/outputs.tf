output "sg_alb" {
  value = {
    id = aws_security_group.alb-sg.id
  }
}

output "sg_app" {
  value = {
    id = aws_security_group.project-sg.id
  }
}

output "sg_endpoint" {
  value = {
    id = aws_security_group.endpoint-sg.id
  }
}
