# coin_management_rails

# 動作確認方法

docker で構築したので docker で動作確認お願いします。

- `docker-compose up -d`
- `docker-compose exec app rails db:create`
- `docker-compose exec app rails db:migrate`

これで宛先`http://localhost:3000/graphql`で動作確認可能です。
クエリの実行は postman であればルートディレクトリにある`gaudiy.postman_collection.json`をインポートして頂けたらテンプレートが入ってます。
直で実行する場合は`http://localhost:3000/graphiql`で GraphQL クライアントが立ち上がります。この場合は spec ディレクトリにあるテストの中のクエリを参照お願いします。

テストは`docker-compose exec app rspec`で実行可能です。

# 課題

- 事前にユーザー情報を登録することによって、そのユーザーは独自コインを管理できるようになります（signup）
  - 登録したときに、ユーザーを一意に表すユーザー ID が生成されます
- ユーザー ID を指定することによって、ユーザーの残高を確認することができます （user）
- ユーザー ID と増加量を指定することによって、残高に独自コインを追加することができます （add_coins）
- ユーザー ID と消費量を指定することによって、残高から独自コインを指定した分、減らすことができます （consume_coins）
- A さん → B さんへの独自コインの送金も行うことができます （send_coins）
- ユーザー ID を指定することによって、今までどんな増加・消費がされたか日時付きで取得することができます。（transactions_by_user）

# 技術選定

一番使い慣れている Rails + GraphQL + PostgresQL で構築しました。

# DB 設計

少しだけ複雑なロジックを組むために実際にこういうアプリを作るとしたらという想定で、設計しました。（erd.pdf）

- balance（残高）カラムやテーブルは transaction と齟齬があるといけないので作成しない
- transaction が増えるとクエリのパフォーマンスが下がるので、ある程度の粒度で集計した balance をまとめるテーブルの作成
  - 今回は daily_balance だが、週とか月とか transaction 数に合わせて設計

ただ、実際の設計であれば、

- user テーブルに複数の account が紐づく形にする
- コインを複数種類持てるようにして、それぞれの account に割り当てる
  という形にすると思います。

# アーキテクチャー

- 基本的に Rails Way に則る（Active Record とか Model に依存する形）
  - 始めからここを崩すと Rails である意味がなくなってしまうため
- ただ、できる限りビジネスロジックは別で切り出す（interactors ディレクトリ）
- 単純な Active Record の組み合わせであれば resolver に直で書く。
  - resolver 自体のテストも可能なので複雑なロジックでなければクラスを無闇に増やさないために resolver で収める
  - クラスで分割しすぎると管理が大変になるのでプロジェクトやメンバーの規模感によるが、Rails 使うような小規模、中規模プロジェクトであれば基本的には 1 モデル（Rails の Model）で収まる処理はクラスは作らずにモデルに書く
- モデル外の共通処理は graphql/concerns にまとめる
- Rails のデザインパターンを利用（今回であれば error オブジェクトと interactor オブジェクト）

# ロジック

本来であれば daily_balance は cron などでレコード作成した方が良いと思いますが、今回は動作確認がしやすいように balance を取得するクエリの中で、レコードが存在しなかったら作成するようなロジックにしました。

# エラーハンドリング

- 異常系、準異常系で処理を分ける
- 異常系：サーバーエラーを返す
- 準異常系：エラーコード、メッセージを返す
- カスタムエラーオブジェクトを作成する

基本的にエラーは Graphql Error で返すようにします。
準異常系はメッセージ付き、異常系はサーバーエラーとして統一されたメッセージを返します。

# テスト

model や interactor の単体テストは今回スキップして、GraphQL の統合テストのみ書きました。

# 作成物に関して

今回作成した主要部分は下記ディレクトリに収まっています。

- rails/app/models
- rails/app/graphql
- rails/app/interactors
- rails/app/errors
- rails/spec
