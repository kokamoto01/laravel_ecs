# 引数指定
Arg1="$1"
Arg2="$2"
Arg3="$3"

# 変数指定
profile="" # プロファイル名を入力
ecr_endpoint="" # ECRエンドポイント(dkr)を入力
local_image="${Arg1}:latest"
remote_image="${ecr_endpoint}/${Arg2}:${Arg3}"

# 実行するコマンド
aws ecr get-login-password --region ap-northeast-1 --profile ${profile} | docker login --username AWS --password-stdin ${ecr_endpoint}
docker tag "${local_image}" "${remote_image}" # タグ付けされたイメージがローカルで作られる
docker push "${remote_image}" # リモートにPush
docker image rm "${remote_image}" # リモートにPushした後、タグ付けされたイメージはローカルでは不要となるので削除

# エラー制御
if [ $? -ne 0 ]; then
echo "Error: コマンドの実行に失敗しました"
exit 1
fi
