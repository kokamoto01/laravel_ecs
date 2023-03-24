## ElasticIP
# NATゲートウェイ用EIP
resource "aws_eip" "ngw_1a" {
  vpc = true
  tags = {
    Name = "test-eip-ngw-1a"
  }
}

resource "aws_eip" "ngw_1c" {
  vpc = true
  tags = {
    Name = "test-eip-ngw-1c"
  }
}

## NATゲートウェイ
resource "aws_nat_gateway" "private_1a" {
  # IGWが作られた後にNGWを作る
  depends_on    = [aws_internet_gateway.main]
  allocation_id = aws_eip.ngw_1a.id
  subnet_id     = aws_subnet.private_1a.id
  tags = {
    Name = "test-ngw-1a"
  }
}

resource "aws_nat_gateway" "private_1c" {
  # IGWが作られた後にNGWを作る
  depends_on    = [aws_internet_gateway.main]
  allocation_id = aws_eip.ngw_1c.id
  subnet_id     = aws_subnet.private_1a.id
  tags = {
    Name = "test-ngw-1c"
  }
}

## サブネット
# パブリックサブネット
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "test-subnet-public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.20.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "test-subnet-public-1c"
  }
}

# プライベートサブネット
resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "test-subnet-private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "test-subnet-private-1c"
  }
}

## ルートテーブル
# パブリック
resource "aws_route_table" "public_1a1c" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0" # インターネットへの通信許可設定
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "test-rtb-public"
  }
}

# プライベート
resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0" # インターネットへの通信許可設定
    nat_gateway_id = aws_nat_gateway.private_1a.id
  }
  tags = {
    Name = "test-rtb-private-1a"
  }
}

resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0" # インターネットへの通信許可設定
    nat_gateway_id = aws_nat_gateway.private_1c.id
  }
  tags = {
    Name = "test-rtb-private-1c"
  }
}

## ルートテーブルとサブネットの関連付け
# パブリックサブネット
resource "aws_route_table_association" "public_1a" {
  route_table_id = aws_route_table.public_1a1c.id
  subnet_id      = aws_subnet.public_1a.id
}

resource "aws_route_table_association" "public_1c" {
  route_table_id = aws_route_table.public_1a1c.id
  subnet_id      = aws_subnet.public_1c.id
}

# プライベートサブネット
resource "aws_route_table_association" "private_1a" {
  route_table_id = aws_route_table.private_1a.id
  subnet_id      = aws_subnet.private_1a.id
}

resource "aws_route_table_association" "private_1c" {
  route_table_id = aws_route_table.private_1c.id
  subnet_id      = aws_subnet.private_1c.id
}

# VPCエンドポイント(s3)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_1a.id, aws_route_table.private_1c.id]
}

# VPCエンドポイント(api)
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-1.ecr.api"
  vpc_endpoint_type = "Interface"

  # プライベートサブネットの指定
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]

  # プライベートDNS名でVPCエンドポイントにアクセスできるように
  private_dns_enabled = true

  # VPCエンドポイントがルートテーブルに追加されるよう、セキュリティグループIDを指定します
  security_group_ids = [aws_security_group.web_vpce.id]
}

# VPCエンドポイント(dkr)
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type = "Interface"

  # プライベートサブネットの指定
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]

  # プライベートDNS名でVPCエンドポイントにアクセスできるように
  private_dns_enabled = true

  # VPCエンドポイントがルートテーブルに追加されるよう、セキュリティグループIDを指定します
  security_group_ids = [aws_security_group.web_vpce.id]
}

# VPCエンドポイント(CloudWatch Logs)
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.web_vpce.id]
}
