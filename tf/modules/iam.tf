# タスク実行ロール
resource "aws_iam_role" "task_execution_role" {
  name = "test-taskexecution-role"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/service-role/AWSTransferLoggingAccess"
  ]
}

# タスクロール
resource "aws_iam_role" "task_role" {
  name = "test-task-role"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Condition = {
        ArnLike      = { "aws:SourceArn" = "arn:aws:ecs:ap-northeast-1:<アカウント名>:*" }
        StringEquals = { "aws:SourceAccount" = "<アカウント名>" }
      }
    }]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}
