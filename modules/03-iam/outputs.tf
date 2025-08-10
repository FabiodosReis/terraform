output "ecs_execution_role" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "task_execution_role" {
  value = aws_iam_role.task-execution_role.arn
}