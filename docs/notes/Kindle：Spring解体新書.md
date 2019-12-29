---
tags:
  - Memo
  - Java
  - Spring
---

# Kindle：Spring解体新書
作成日：2019/07/14

---

## Lombakインストール時の困りごと

IDEsに表示されない。
SpringToolSuits.iniを指定する

## Eclipseの補完設定の変更
とりいそぎJavaとWebの補完。
補完が始まるキーワード追加、Weight下げ。
SQLEditor追加。

* hogeString,hogeDateみたいに型を勝手に付加する補完が邪魔。
* Enter以外で反応しないで欲しい。
![](https://i.imgur.com/iqgHQAt.png)


* 閉じカッコで文末に飛ばないで欲しい
* thymeleafに対する補完、Lint


# 後で詳しく学ぶ
* thymeleaf
* Bootstrap
* Dependency Injection
* th:includeのプリプロセッシング
* トランザクション伝搬レベル
* passwordEncoderの種類と実装

# その他
## Vim
日本語モードで編集モードに入るように設定

## thymeleaf拡張とSpringSecutiryのバージョン問題

## タイピング練習
```html
<html xlmns:th="http://www.thymeleaf.org"
      xlmns:layout="http://www.ultraq.net.nz/thymeleaf/layout"
      xlmns:sec="http://www.thymeleaf.org/thymeleaf-extras-springsecurity4">
```