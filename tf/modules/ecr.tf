## ECR
# PHPコンテナ
resource "aws_ecr_repository" "app" {
  name = "app-repo"
}
# ライフサイクルポリシー
resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name
  policy     = <<EOF
    {
        "rules": [
            {
            "action": {
                "type": "expire"
            },
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "description": "delete cycle",
            "rulePriority": 1
            }
        ]
    }
    EOF
}

# Nginxコンテナ
resource "aws_ecr_repository" "web" {
  name = "web-repo"
}
# ライフサイクルポリシー
resource "aws_ecr_lifecycle_policy" "web" {
  repository = aws_ecr_repository.web.name
  policy     = <<EOF
    {
        "rules": [
            {
            "action": {
                "type": "expire"
            },
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "description": "delete cycle",
            "rulePriority": 1
            }
        ]
    }
    EOF
}
