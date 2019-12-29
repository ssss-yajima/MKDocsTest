---
tags:
  - develop
  - Java
  - Spring
---

# ToDoアプリ開発記録 1
作成日：2019/07/28

---
#### 2019/07/29

login画面とsignup画面、Controllerをまず作成。

### SpringSecurityの依存関係を追加するだけでBasic認証がかかる

#### Spring1.Xの場合
application.propertiesに以下を追加すると無効化。
`security.basic.enabled = false`
http://teachingprogramming.net/archives/563

#### Spring２．Xの場合
SecurityConfigで画面ごとに設定が必要。無条件に許可する場合は以下の通り。
https://intellectual-curiosity.tokyo/2019/04/14/spring-boot-2-x-%E3%81%A7basic%E8%AA%8D%E8%A8%BC%E3%82%92%E7%84%A1%E5%8A%B9%E3%81%AB%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95/

##### SecurityCnonfiguration.java
```java=
package com.example.demo;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration  extends WebSecurityConfigurerAdapter{
    @Override
    protected void configure(HttpSecurity http) throws Exception{
        http.authorizeRequests().antMatchers("/").permitAll();
    }
}
```
## 困りごと
htmlファイル中のタイポがつらい。

---

#### 2019/08/13
ログイン、ユーザー登録まで完了。
現時点でノウハウとかはなく、覚える段階。

---

# ToDOアプリ 残タスク・課題
- [ ]ServiceとDao関数の命名
- [ ]簡易的なクラス図を書く
- [ ]フロントとバックのやりとりはプリミティブに最小要素か、クラスで受け渡すか
- [ ]テスト駆動をサクサク進めるためのキー操作パターン
- [ ]CRUD処理のテストコード読む
- [ ]Model,Dao,Serviceにテストコード書く
- [ ]Equalsメソッドを実装しなおす(Hash)
- [ ]ToDoアプリをAPI＋フロントに分離するß

# ポモドーロ開発に向けて
- 簡易的なクラス図を書く
