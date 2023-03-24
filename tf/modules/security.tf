## セキュリティグループ
# ルールはここで追加せず、aws_security_group_ruleで追加すること。
resource "aws_security_group" "web_server" {
  name   = "test-sg-web-server"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "test-sg-web-server"
  }
}

resource "aws_security_group" "web_lb" {
  name   = "test-sg-web-lb"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "test-sg-web-lb"
  }
}

resource "aws_security_group" "web_vpce" {
  name   = "test-sg-web-vpce"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "test-sg-web-vpce"
  }
}

## (Webサーバ)セキュリティグループルール
# インバウンド
resource "aws_security_group_rule" "web_server_inbound" {
  security_group_id        = aws_security_group.web_server.id # 適用するセキュリティグループ
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"                         # 全てのプロトコル
  source_security_group_id = aws_security_group.web_lb.id # ALBからのアクセスを許可
}

# アウトバウンド
resource "aws_security_group_rule" "web_server_outbound" {
  security_group_id = aws_security_group.web_server.id # 適用するセキュリティグループ
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] # インターネットへのアクセス
}


## (Webサーバ用ALB)セキュリティグループルール
# インバウンド
resource "aws_security_group_rule" "web_lb_inbound_http" {
  security_group_id = aws_security_group.web_lb.id # 適用するセキュリティグループ
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # インターネットからのアクセス
}

# # アウトバウンド
resource "aws_security_group_rule" "web_lb_outbound" {
  security_group_id = aws_security_group.web_lb.id # 適用するセキュリティグループ
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] # インターネットへのアクセス
}

## (Webサーバ用VPCエンドポイント)セキュリティグループルール
# インバウンド
resource "aws_security_group_rule" "web_vpce_inbound" {
  security_group_id        = aws_security_group.web_vpce.id # 適用するセキュリティグループ
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_server.id
}

# アウトバウンド
resource "aws_security_group_rule" "web_vpce_outbound" {
  security_group_id = aws_security_group.web_vpce.id # 適用するセキュリティグループ
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] # インターネットへのアクセス
}
