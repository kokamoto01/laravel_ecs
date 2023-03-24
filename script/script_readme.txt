※それぞれの環境が異なるため、必ず変数を確認すること
・1行目の変数にはAWS CLIのプロファイル名を指定してください
・2行目の変数には<AWSアカウントID>.dkr.ecr.<リージョン名>.amazonaws.comを指定してください

以下実行例
・引数1には、イメージ名を入れてください
・引数2には、リポジトリ名を入れてください
・引数3には、つけたいタグ名を入れてください

bashスクリプトの場合 (gitbashを使っての動作確認を行いました)
$ ./script/push_ecr.sh training-image training-repo test

Powershellスクリプトの場合 (動作確認取れていません。)
PS> ./script/push_ecr.ps1 training-image training-repo test
