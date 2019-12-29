---
tags:
  - blog
  - Java
---

# STS(Spring Tool Suits4)にLombak導入
作成日：2019/07/28

---
STSにLombok入れようとした際に困った点の備忘。  

## 環境
Eclipse : Spring Tool Suits 4(Version: 4.3.1.RELEASE)  
Lombok : v1.18.8  
（2019/07/28時点）

# 導入手順
* [公式](https://projectlombok.org/download)からjarファイルをダウンロード
* ダブルクリックで実行し、導入するIDEを選択する

だけのはずが、私の環境ではIDE候補が表示されなかった。
![](https://i.imgur.com/b0jzJUP.png)

「Specify Location」を選んで手動でIDEを指定するようにとあるが、SpringToolSuits4.appやそれっぽいフォルダを選択できないので、どうしていいか分からず。

結論として、IDEの設定ファイル(ini)を指定する必要があった。

**Applications > SpringToolSuits4.app > Contents > Eclipse > SpringToolSuits4.ini**  

を選択し、「Install/Update」を押して実行するとSTS４にLombokが導入される。