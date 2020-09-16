# MKDocsTest

MKDocs によるドキュメント作成の実験場

Github Pages

https://y-megane.github.io/MKDocsTest/toplevel_1/

---

## ドキュメント追加手順

---

## ローカル動作手順

### docker 利用の場合

##### 前提

- docker がインストール済であること

##### ローカルでプレビューを見たい場合

`docker-compose up -d`で起動してブラウザから`http://localhost:8000`にアクセスする。

##### ビルドする場合

`docker-compose run --rm mkdocs mkdocs build`

### ローカルインストールの場合

##### 前提

- python3 系がインストール済であること

##### 環境構築

- 依存ライブラリをインストール `pip install -r requirements.txt`

##### ローカルでプレビューを見たい場合

`mkdocs serve` で起動してブラウザから`http://localhost:8000`にアクセスする。

##### ビルドする場合

`mkdocs build`
