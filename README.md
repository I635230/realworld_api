# Realworld API

ブログプラットフォームを作る[RealWorld](https://github.com/gothinkster/realworld/tree/main)というOSSのプロジェクトがあります。これは実在するものと同じ機能を持つサイトを作成することで、学習したいフレームワークの技術を習得することを目的とするプロジェクトです。

そのRealWorldに則り、Medium.comのクローンサイトである[Conduit](https://demo.realworld.io/#/)のバックエンド(API部分)をRuby on Railsで作成したという内容です。

本リポジトリは、株式会社ユーブルが運営するサービス「アプレンティス」における学習の一環で作成したものになります。

## Conduitとは
Medium.comは、ユーザーがログインをして記事を投稿するサイトです。

Conduitはそんなサイトのクローンとして作成するので、ユーザーの登録、ログイン/ログアウト機能、記事の投稿機能などが求められます。

## 本リポジトリについて
Dockerで作成したRuby on Railsアプリとなります。

ルート直下にはdockerfile, compose.ymlが存在し、rails serverは`docker-compose`コマンドで起動することになります。

その他は`rails new --api`で作成した通常のRailsアプリの構成と変わりません。

## 使用技術
- Ruby 3.2.2
  - Ruby on Rails 7.0.4.3
  - sqlite3 1.6.1

## 実装したもの
- JWTトークンを用いた認証
- ユーザーの登録/表示/編集
- 他ユーザー情報の表示
- フォロー
- 記事の投稿/表示/編集/削除
- 記事へのコメントの投稿/表示
- お気に入り
- タグ

## 使用方法
本リポジトリを`git clone`で取得してから、以下のコマンドを実行してください。

```
docker-compose build
docker-compose up -d
docker-compose run web rails db:create
docker-compose run web rails db:migrate
```

後は[Endpoints | RealWorld](https://realworld-docs.netlify.app/docs/specs/backend-specs/endpoints/)に従って、[http://localhost:3000](http://localhost:3000)にHTTPリクエストを送ってください。

期待されるレスポンスの例は[API Response format | RealWorld](https://realworld-docs.netlify.app/docs/specs/backend-specs/api-response-format/)を参照してください。