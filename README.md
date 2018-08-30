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

## やること
- emulatorが外部から接続できることを確認する

- 別にcbtのコンテナを立てて接続する．余裕があればコードから接続
- `gcloud beta emnulators bigtable start --host-port localhost:8086`がダメだったぽい
  - `gcloud beta emulators bigtable start --host-port 0.0.0.0:8086`でやってみる
- `localhost`と`0.0.0.0`の違いは何か
- emulatorとは何なのか

### cbtコンテナ
- golangのコンテナにcbtコマンドとgcloudコマンドえおインストール

### emulatorコンテナ
- とりあえずなんとなくできてる．Dockerfile参照


## やったこと
- やはりcbtコンテナから`localhost:8086`を指定してもcbtコンテナのlocalhostを指してしまうっぽい
- じゃあどうするか
  - ローカルマシンのipを直接指定する
  - `host.docker.internal`でコンテナ内からホストへアクセスできる
    - `rpc error: code = Unavailable desc = transport is closing`
    - keepalive?
  - emulatorコンテナのipを直接指定する
    - `rpc error: code = Unavailable desc = all SubConns are in TransientFailure, latest connection error: connection error: desc = "transport: Error while dialing dial tcp 172.17.0.2:8086: connect: connection refused"`
  - dockerの`--link`オプションを使ってcbt のコンテナからemulatorのコンテナに直接アクセスできるようにしてみる
    - よくわからないけどエラー変わらず

- やはり方向性としては`cbt_container -> localhost -(port forward)-> emulator_container`的な感じで間違ってはいないはず．

- ローカル環境にcbtとgcloudインストールして試した
  - `~/.config/gcloud/emulator/bigtable/env.yum`をマウントすればエラーなく`$(gcloud beta emulators bigtable env-init)`が実行できるが，cbtコマンドは実行できない
  - ローカルでemulator起動すればローカルのcbtコマンド使える．同一コンテナ内でcbt使えたのと一緒，再現性あり．
- 同じマシン上で起動していると考えない方がいいか？
- リモートに接続するイメージか，sshとか？コードからいけるか試す．