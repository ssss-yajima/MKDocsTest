---
tags:
  - develop
  - Java
  - Spring
---

# ToDoアプリ
作成日：2019/07/28

---
# ユーザーストーリー
## 今回実装する
* ログイン・ログアウトする
* タスクを追加・削除する
* タスクごとに完了ボタンを設け、クリックすることで完了する
* 完了したタスクは文字色を薄くする
* 完了タスクの表示・非表示を切り替える
* APIでID指定してタスク一覧をGETすする

## 後で機能拡張する
* ドラッグ＆ドロップで並び替える
* サブタスクを作る
* タスクリストを複数作って切り替える
* タスクリストを他人と共有・解除する
* タスク消化数のレポートを作成する
* タスクリストを横に複数並べて相互に移動する（かんばん）

# 全体設計

# 画面設計

## 画面遷移

## 画面詳細

# DB設計

## テーブル定義
```sql
CREATE TABLE IF NOT EXISTS user(
    user_id VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    user_name VARCHAR(50
);

CREATE TABLE IF NOT EXISTS task(
    task_id INT(10) PRIMARY_KEY AUTO_INCREMENT,
    user_id VARCHAR(50) NOT NULL,
    task_title VARCHAR(100),
    done_flas BOOLEAN DEFAULT 0 NOT NULL
);
```
外部キー制約できるDBならtaskテーブルのuser_idをuserテーブルのuser_idに紐付ける。