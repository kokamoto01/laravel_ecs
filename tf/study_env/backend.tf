terraform {
  backend "s3" {                           // この設定で State ファイルが S3 に保存されます
    bucket = ""                            // State ファイルを配置するバケット名を入力
    key    = "terraform.tfstate"           // State ファイルを配置するパス・ファイル名
    region = "ap-northeast-1"              // S3のリージョン
  }
}
