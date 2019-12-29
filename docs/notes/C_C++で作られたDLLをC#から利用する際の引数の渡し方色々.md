---
tags:
  - blog
  - C#
  - survey
---

# C/C++で作られたDLLをC#から利用する際の引数の渡し方色々
作成日:2019/8/11

---
C言語で書かれたDLLをC#から扱う際に引数の受け渡しが分からなくて色々調べたので、その備忘。

## intを引数にとる関数
```cpp=
//C++
//intを受け取って表示し、1加えて返す
int __stdcall MyFuncA(int a) {
    printf("C++ : int a = %d\n", a);
    return a + 1;
}
```
```csharp=
//C#
[DllImport("MyDll.dll")]
private static extern int MyFuncA(int a);

int ans = MyFuncA(1);
Console.WriteLine(ans);
```
```
出力結果
C++ : int a = 1
```

## int*を引数にとる関数
※C#からDLLに値を渡すことはできるが、**DLL側での操作がC#の変数に反映できてない。**  
私の用途ではコレで困らなかったが、C#側にDLL側の操作を反映するにはこれではダメ。要調査。
```cpp=
//C++
//intのポインタを受け取って値を変更。前後の値を出力する。
void __stdcall MyFuncG(int* a) {
    printf("C++ : a = %d\n", *a);
    int x = 100;
    a = &x;
    printf("C++ : a = %d\n", *a);
}
```
```csharp=
//C#側
[DllImport("MyDll.dll")]
private static extern void MyFuncG(ref int a); //refで参照渡し

int a = 77;
Console.WriteLine($"C# : a = {a} -- before");
MyFuncG(ref a);
Console.WriteLine($"C# : a = {a} -- after");
```
```
出力結果
C# : a = 77 -- before
C++ : a = 77           //値を渡すことはできている
C++ : a = 100
C# : a = 77 -- after   //DLL側での操作が反映できていない
```
## cahr*を引数にとる関数（入力のみ）
```cpp=
//C++
void __stdcall MyFuncB(char* str) {
    printf("C++ : %s\n", str);
}
```
```csharp=
//C#
[DllImport("MyDll.dll")]
private static extern void MyFuncB(string str);

MyFuncB("call MyFuncB from C#");
```
```
出力結果
C++ : call MyFuncB from C#
```
## char*を引数にとる関数（文字列を操作する）
```cpp=
//C++
void __stdcall MyFuncC(char* str) {
    printf("C++ : before : %s\n", str);
    sprintf_s(str, 256, "Set By MyFuncC");
    printf("C++ : after  : %s\n",str);
```
```csharp=
//C##
[DllImport("MyDll.dll")]
//文字列を操作する関数に対してStringBuilderを渡す
private static extern void MyFuncC(StringBuilder str);

StringBuilder sb = new StringBuilder("Before Str",256);
MyFuncC(sb);
Console.WriteLine("C# : " + sb);
```
```
出力結果
C++ : before : Before Str
C++ : after  : Set By MyFuncC
C# : Set By MyFuncC            //DLL内での変更が反映されている
```
## 構造体を引数にとる関数
```cpp=
//C++側
typedef struct _SampleStruct {
	int index;
	char name[128];
	int data[50];
}SampleStruct

void __stdcall MyFuncD(SampleStruct st) {
    printf("C++ : index = %d\n", st.index);
    printf("C++ : name = %s\n", st.name);
    printf("C++ : data = {%d, %d, %d}\n",
            st.data[0], st.data[1], st.data[2]);
}
```
```csharp=
//C#
[DllImport("MyDll.dll")]
private static extern void MyFuncD(SampleStruct st);

//構造体定義
//構造体の型、大きさ、順序を揃える。
[StructLayout(LayoutKind.Sequential)]
private struct SampleStruct
{
    public int index;

    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)] //固定長文字列配列
    public string name;

    //固定長配列
    [MarshalAs(UnmanagedType.ByValArray, SizeConst = 50)] //固定長配列
    public int[] data;
}

//構造体の初期化
var st = new SampleStruct()
{
    index = 4,
    name = "構造体サンプル",
    data = new int[50],
};
st.data[0] = 10;
st.data[1] = 20;
st.data[2] = 30;
MyFuncD(st);

```
```
出力結果
C++ : index = 4
C++ : name = 構造体サンプル
C++ : data = {10, 20, 30}
```

## 構造体のポインタを引数にとる関数
```cpp=
//C++
//構造体は上と同じものを利用
void __stdcall MyFuncE(SampleStruct* pst) {
    (*pst).index = 55;
    sprintf_s((*pst).name, "構造体ポインタサンプル");
    (*pst).data[0] = 51;
    (*pst).data[1] = 52;
    (*pst).data[2] = 53;
}
```
```csharp=
//C#
//構造体は上と同じものを利用

[DllImport("MyDll.dll")]
//SampleStruct*に対してIntPtrを渡す
private static extern void MyFuncE(IntPtr pst);

var pst = Marshal.AllocHGlobal(Marshal.SizeOf(typeof(SampleStruct)));
try
{
    MyFuncE(pst);
    
    var st_rtn = (SampleStruct)Marshal.PtrToStructure(pst, typeof(SampleStruct));
    Console.WriteLine($"C# : index = {st_rtn.index}");
    Console.WriteLine($"C# : name = {st_rtn.name}");
    Console.WriteLine($"C# : data = [{st_rtn.data[0]},{st_rtn.data[1]},{st_rtn.data[2]}]");
}
catch (Exception e)
{
    System.Diagnostics.Debug.WriteLine(e);
}
finally
{
    //必ずメモリ解放
    Marshal.FreeHGlobal(pst);
}
```
```
出力結果
C# : index = 55                //DLL側の操作が反映されている
C# : name = 構造体ポインタサンプル
C# : data = [51,52,53]
```

## 構造体のポインタのポインタを引数にとる関数
```cpp=
//C++
//ポインタのポインタを引数にとるが処理内容は上と同じ
void __stdcall MyFuncI(SampleStruct** ppst) {
    (**ppst).index = 70;
    sprintf_s((**ppst).name, "構造体ポインタのポインタのサンプル");
    (**ppst).data[0] = 11;
    (**ppst).data[1] = 22;
    (**ppst).data[2] = 33;
}
```
```csharp=
//C#
//構造体は上と同じものを利用

[DllImport("MyDll.dll")]
//構造体SampleStructのポインタのポインタを渡す
unsafe private static extern void MyFuncI(ref IntPtr ppst);

//ref IntPtrを渡していること以外は構造体のポインタを渡した場合と同様
var pst = Marshal.AllocHGlobal(Marshal.SizeOf(typeof(SampleStruct)));
try
{
    MyFuncI(ref pst); // ref IntPtrとして構造体を指すポインタの参照を渡す
    
    var st_rtn = (SampleStruct)Marshal.PtrToStructure(pst, typeof(SampleStruct));
    Console.WriteLine($"C# : index = {st_rtn.index}");
    Console.WriteLine($"C# : name = {st_rtn.name}");
    Console.WriteLine($"C# : data = [{st_rtn.data[0]},{st_rtn.data[1]},{st_rtn.data[2]}]");
}
catch (Exception e)
{
    System.Diagnostics.Debug.WriteLine(e);
}
finally
{
    //必ずメモリ解放
    Marshal.FreeHGlobal(pst);
}
```
```
出力結果
C# : index = 70                          //DLL側の操作が反映されている
C# : name = 構造体ポインタのポインタのサンプル
C# : data = [11,22,33]
```

## おわり
C、C++,C#いずれも全然習熟していない状態なので、もっとスマートな実装方法があるかもしれない。マサカリお待ちしてます。  
ただポインタのポインタを受け渡す例などは調べても全然出てこなかったので、ニッチな困りごとの一助になれば幸いです。

## 参考
* [【保存版】構造体のマーシャリングのまとめ](https://tech.blog.aerie.jp/entry/2015/08/13/155225)
* [Win32 APIやDLL関数を呼び出すには？](https://www.atmarkit.co.jp/ait/articles/0305/09/news004.html)