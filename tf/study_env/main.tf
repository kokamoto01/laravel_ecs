#####################################
# Terraform Settings
#####################################
terraform {
  required_version = "~> 1.2.0" // Terraform のバージョン
  required_providers {          // Provider の設定
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0" // AWS Provider のバージョン
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "modules" {
  source = "../modules"
}
