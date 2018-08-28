## イメージ作成 (build)
```
docker build -t イメージ名 .
```

## コンテナ起動
```
docker run -it -p 8086:8086 イメージ名
```

## その他
- ローカルでcbtコマンド使う場合は，`$(gcloud beta emulators bigtable env-init)`コマンドでエミュレータの接続先をローカルホストに設定
  - これ実行しないと credential error でる

- `cbt -project プロジェクト名 -instance インスタンス名 -creds クレデンシャル コマンド`で実行

- 面倒臭かったら`/root/.cbtrc`に
```
project = プロジェクト名
instance = インスタンス名
creds = クレデンシャル
```
