---
tags:
  - survey
  - Memo
  - C#
---

# C#からDLL利用
作成日：2019/8/4

---
## 参考
* https://tech.blog.aerie.jp/entry/2015/08/13/155225
* https://www.atmarkit.co.jp/ait/articles/0305/09/news004.html
* http://typea.info/tips/wiki.cgi?page=C%23+Win32+API+%A4%AA%A4%E8%A4%D3+DLL+%A4%CE%CD%F8%CD%D1#p4
* https://docs.microsoft.com/ja-jp/dotnet/framework/interop/default-marshaling-for-strings
* https://docs.microsoft.com/ja-jp/dotnet/framework/interop/default-marshaling-behavior


## C#でDLLを作ってC#で呼び出す
### 作る
プロジェクト作成時に「クラスライブラリ」
を指定するだけ。
### 呼ぶ
参照設定にDLLを指定してusingするだけ。

## C/C++DLLをC#から呼ぶ
DLLを読み込むクラスを作ると分かりやすい。
```csharp=
// DLLの関数を読んでいることが明示的になる
DllClass.dllFunction(x,y,z);
```
### 単純な型を渡すとき
```csharp=
using System.Runtime.InteropServices;
[DllImport("dllname.dll")]
static extern void func(int x, int y);
```
### 構造体を渡すとき
#### 入力として渡す
呼出し先のC++構造体(PtInRect)
```cpp=
BOOL PtInRect(
  const RECT *lprc,
  POINT      pt
);
```
利用側のC#
```csharp=
BOOL SetRect(
  LPRECT lprc,
  int    xLeft,
  int    yTop,
  int    xRight,
  int    yBottom
);
//呼出し先の引数がRECTのポインタなのでC#側はREFで参照を渡す
[DllImport("user32.dll")]
private static extern bool PtInRect(ref RECT r, POINT p);
```
#### 出力先として渡す
呼出し先のC++構造体(PtInRect)
```cpp=
BOOL PtInRect(
  const RECT *lprc,
  POINT      pt
);
```

利用側のC#
```csharp=
//出力を受け取るためクラスとして定義
[StructLayout(LayoutKind.Sequential)]
public class RECT_CLASS
{
    public int left;
    public int top;
    public int right;
    public int bottom;

    public override string ToString()
    {
    return $"{left} {top} {right} {bottom}";
    }
}
//出力を受け取るため[Out]を付けて渡す
[DllImport("user32.dll")]
private static extern bool SetRect(
    [Out] RECT_CLASS lprc, int xLeft, int yTop, int xRight, int yBottom);

//テスト関数
internal static void TestSetRect()
{
    RECT_CLASS r = new RECT_CLASS();
    SetRect(r, 0, 0, 7, 7);
    Debug.WriteLine("TestSetRect");
    Debug.WriteLine(r.ToString());
}
```
#### 入出力の場合
```csharp=
//出力を受け取るため[Out]を付けて渡す
[DllImport("user32.dll")]
private static extern bool SetRect(
    [In][Out] RECT_CLASS lprc, int xLeft, int yTop, int xRight, int yBottom);
```
他は上記の出力側と同じ。
程よい関数が見つからなかったので全体の実装はなし。