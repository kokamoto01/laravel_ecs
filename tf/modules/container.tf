# ECSクラスター
resource "aws_ecs_cluster" "main" {
  name = "test-cluster"
}

# ECSサービス
resource "aws_ecs_service" "main" {
  name        = "test-service"
  cluster     = aws_ecs_cluster.main.arn
  launch_type = "FARGATE"
  # 最新のリビジョンをdataで取得(手動やCodePipeline等でタスク定義更新した場合、リビジョンがずれるため)
  task_definition = data.aws_ecs_task_definition.main.arn
  desired_count   = 1
  # ネットワーク設定
  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.web_server.id]
    subnets          = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]
  }
  # ALBのターゲット設定
  load_balancer {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "web"
    container_port   = 80
  }
}

# ECSタスク定義
resource "aws_ecs_task_definition" "main" {
  family                   = "test-taskdefinition"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  # コンテナ定義
  container_definitions = jsonencode([
    {
      "name" : "app",
      "image" : "<appイメージのURI>",
      "cpu" : 0,
      "portMappings" : [
        {
          "containerPort" : 9000,
          "hostPort" : 9000,
          "protocol" : "tcp"
        }
      ],
      "essential" : true,
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : "/ecs/logs/test",
          "awslogs-region" : "ap-northeast-1",
          "awslogs-stream-prefix" : "app"
        }
      }
    },
    {
      "name" : "web",
      "image" : "<webイメージのURI>",
      "cpu" : 0,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80,
          "protocol" : "tcp"
        }
      ],
      "essential" : true,
      "volumesFrom" : [
        {
          "sourceContainer" : "app"
        },
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : "/ecs/logs/test",
          "awslogs-region" : "ap-northeast-1",
          "awslogs-stream-prefix" : "web"
        }
      }
    }
  ])
}

# 最新のリビジョンをdataとして保管(手動更新やCodePipeline等でタスク定義更新した場合、リビジョンがずれるため)
data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.main.family
}
