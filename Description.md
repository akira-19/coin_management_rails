# 課題

下記ケースのときにどういった対処が取れるか？に関して自由に記述してください。（文章ベースでも図ベースでも問題ありません。）

特に正解不正解はなく、どういった行動を意思決定するのかを知るための課題です。

複数の BE アプリケーションを本番環境で運用する場合、どのようなことを気にしながらどんな PF（クラウドや PaaS、IaaS、CaaS 等）を利用してサービスを開始しますか？

実際によく利用するものやこういうのを利用したいんだよなと思ったりするものを、自由形式で記述いただきたいです。

GitHub での運用やデプロイメントパイプライン文脈（CI/CD）や監視・セキュリティ文脈の視点も取り入れて記述いただくとなおありがたいです。

# 回答

GCP は経験があまりない（VM とか Bigquery くらい）ので、AWS のサービス で回答します。

大きく 6 つの項目に分けて考えます。

- 環境構築、運用の容易さ
- セキュリティ
- 監視
- 信頼性
- スケーラビリティ
- コスト

これを考慮したときに状況や仕様にもよりますが、一般的な本番環境の第一選択は AWS で ECS Fargate を使った添付図（structure.png）のような構成です。
Fargate を選ぶ理由として、上記の 6 点を考慮すると、以下のようになります。

- 環境構築、運用の容易さ
  - イメージを push してデプロイするだけなので構築が容易
  - CaaS は開発を docker 環境で行っていれば基本的に環境による動作不良が起きない（絶対ないわけではないですが）
  - Github Actions での CI/CD の設定もあまり複雑でないし、AWS 公式の actions がちゃんと動く
- セキュリティ
  - Fargate に限らないが、基本的に閉じた系（プライベートサブネット）に環境を作って、外部への露出は最低限にする
  - ALB に WAF の設定（AWS WAF や AWS Shield）の追加する（これも簡単に行える）
- 監視
  - アプリのログ（標準出力）や WAF のログは CloudWatch に残せるので、それで基本的なログの確認は可能
  - システムのメトリクス（CPU 使用率など）も確認やアラートの設定も行う
  - Lambda を使って、例えば Slack に毎日メトリクスのグラフを通知（これ Azure だとちょっと難しいです）
  - s3 にログをエクスポートして、ログ分析も可能
  - もしくは sidecar コンテナ含めればもっと細かいメトリクスも取得可能
- 信頼性
  - 複数ゾーンに振り分ければ基本的にサーバーが落ちる可能性は限りなく低い
  - リージョンの振り分けも可能なので、信頼性が最重要であったりグローバルサービスであれば複数リージョンでの運用も可能
- スケーラビリティ
  - メトリクスとターゲット値を指定することで水平スケーリングが可能
- コスト
  - EC2 と比べても料金は大きくは変わらない（2~3 割くらい高いイメージ）
  - コストをかなり絞ろうするのであれば EC2 の方が安いが管理コストを考えると ECS+Fargate が第一選択

他の環境としては、

アクセス頻度や使用リソースの全体管理が Kuberenetes の方がしやすいので、マイクロサービス化したアプリケーションが多くなる場合には Kubernetes を使ったほうがコスト優位になるのかなと思います。

もしくは仕様によっては Lambda 等使ったサーバーレスアーキテクチャを考えます。
シンプルな CRUD であれば API gateway とか App Sync 使えばバックエンドの実装なしで運用可能なので、運用するアプリケーションの中にシンプルなものが含まれていれば、そのアプリに関してはこちらを選択し、ECS との併用も考えます。もしくは、非同期の別処理（例えば画像のリサイズ等）は Lambda に分離することも考えます。
Hasura は使ったことないですが、App Sync と同じであれば resolver を多少拡張できるので色々なケースで利用可能かなと思います。

マネージドサービスを使うと環境構築手順が単純であるため、不具合が起きたときの再現、対処がしやすいのと、ミドルウェアを勝手に更新してくれるので、IaaS よりマネージドサービスを選ぶことが多いです。
