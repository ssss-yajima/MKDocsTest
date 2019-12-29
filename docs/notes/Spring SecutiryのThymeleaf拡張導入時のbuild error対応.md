---
tags:
  - blog
  - Java
  - Spring
  - Doing
---

# Spring SecutiryのThymeleaf拡張導入時のbuild error対応
作成日：2019/07/28

---
# 背景
Kingle本の[Spring解体新書](https://www.amazon.co.jp/%E3%80%90%E5%BE%8C%E6%82%94%E3%81%97%E3%81%AA%E3%81%84%E3%81%9F%E3%82%81%E3%81%AE%E5%85%A5%E9%96%80%E6%9B%B8%E3%80%91Spring%E8%A7%A3%E4%BD%93%E6%96%B0%E6%9B%B8-Boot2%E3%81%A7%E5%AE%9F%E9%9A%9B%E3%81%AB%E4%BD%9C%E3%81%A3%E3%81%A6%E5%AD%A6%E3%81%B9%E3%82%8B%EF%BC%81Spring-Security%E3%80%81Spring-JDBC%E3%80%81Spring-MyBatis%E3%81%AA%E3%81%A9%E5%A4%9A%E6%95%B0%E8%A7%A3%E8%AA%AC%EF%BC%81-ebook/dp/B07H6XLXD7)
の写経にあたって、Spring Securityの章でThymeleafのSpring Security拡張を導入する必要がるのだが、私の作業だと以下のようなbuild errorが発生して詰まった。
その原因と対応の備忘。

発生したエラー(pom.xml)
`
Project build error: 'dependencies.dependency.version' for org.thymeleaf.extras:thymeleaf-extras-springsecurity4:jar is missing.	`

# 問題
pom.xmlにThymeleaf拡張のdependencyを追加したら上の通りエラーが発生。

pom.xml（一部）
```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.1.6.RELEASE</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>

<properties>
    <java.version>1.8</java.version>
</properties>

<dependencies>
    <!-- 省略 -->
    
    <!-- SpringSecutity -->
    <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-security</artifactId>
   </dependency>
   
    <!-- Thymeleaf拡張（セキュリティ） -->
     <dependency>
       <groupId>org.thymeleaf.extras</groupId>
       <artifactId>thymeleaf-extras-springsecurity4</artifactId>
       </dependency>
</dependencies>
```

# 原因
Thymeleaf拡張のバージョンを指定していなかったため、

# 解決策