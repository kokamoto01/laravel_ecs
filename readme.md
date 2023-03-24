## README
### 前提条件
- Dockerインストール、起動済み
- AWSのアクセスキー取得済み
- ローカルのAWSCLIでスイッチロール用のProfile設定済み

### ディレクトリ構成
```C:Users\<ユーザー名>``` から1つ下のフォルダを想定しています。  
例: ```C:\Users\okamoto\(このディレクトリ)```
```
.
|-- docker/
    |-- nginx/
        |-- default.conf
        |-- Dockerfile
    |-- php/
        |-- php.ini
        |-- Dockerfile
|-- script/
    |-- push_ecr.ps1 (DockerイメージをECRにPush Powershell用(使用非推奨))
    |-- push_ecr.sh (DockerイメージをECRにPush bash用)
    |-- script_readme.txt
|-- tf/
    |-- molules/
        |-- xxx.tf (vpc, ec2等)
    |-- xxx_env/ (作成したい環境ごとに作成)
        |-- main.tf
        |-- backend.tf
|-- src/ (Laravelアプリの配置場所)
|-- .env.example
|-- .gitignore
|-- docker-compose.yaml
|-- readme.md
```

### How to Use Terraform
1. .envファイルを作成 (書き方は.env.example参照)  
    ```.env
    AWS_SHARED_CREDENTIALS_FILE=/.aws/credentials
    AWS_CONFIG_FILE=/.aws/config
    AWS_PROFILE=<プロファイル名>
    ```
2. PowerShellを使ってdocker-compose.yamlがあるディレクトリで以下のコマンドを実行  
    ``docker-compose up -d terraform``

3. Dockerコンテナ内部に入る (bashではなく、ashなので注意)  
    ``docker-compose exec terraform /bin/ash``

4. カレントディレクトリが /workdir であることを確認
    ``pwd``

5. xxx.env (xxxは各環境)ディレクトリに移動して初期化コマンドを実行  
    ```
    cd xxx.env
    terraform init
    ```

6. terraformコマンドを実行  
    ``terraform plan``


#### よく使うTerraformコマンド一覧
```
terraform fmt <ファイル名>      # 整形
terraform validate              # 構文チェック
terraform plan                  # ドライラン
terraform apply                 # 作成
```
