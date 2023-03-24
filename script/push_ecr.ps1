# 引数指定
param(
    [String]$Arg1,
    [String]$Arg2,
    [String]$Arg3
)

# 変数指定
$profile = "" # プロファイル名
$ecr_endpoint = "" # ECRエンドポイント(dkr)
$local_image = "$($Arg1):latest"
$remote_image = "$ecr_endpoint/$($Arg2):$($Arg3)" 

# 実行するコマンド
try {
    aws ecr get-login-password --region ap-northeast-1 --profile $profile | docker login --username AWS --password-stdin $ecr_endpoint
    docker tag $local_image $remote_image # タグ付けされたイメージがローカルで作られる
    docker push $remote_image # リモートにPush
    docker image rm $remote_image # リモートにPushした後、タグ付けされたイメージはローカルでは不要となるので削除
} catch {
    Write-Error "Error: $($_.Exception.Message)"
}

# Docker起因のエラーで通用しないので一旦コメントアウト
# Write-Output "$($Arg2)に$($Arg1)をPushしました。(タグ名:$($Arg3))"
