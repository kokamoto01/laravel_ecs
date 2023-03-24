## ロードバランサ
resource "aws_lb" "web" {
  name               = "test-web-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_lb.id]
  subnets            = [aws_subnet.public_1a.id, aws_subnet.public_1c.id]
  tags = {
    Name = "test-web-lb"
  }
}

## ターゲットグループ
resource "aws_lb_target_group" "web" {
  name        = "test-web-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 300
  }
  tags = {
    Name = "test-web-lb-tg"
  }
}

## リスナー
resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
