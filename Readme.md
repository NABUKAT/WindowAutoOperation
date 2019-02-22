## 概要
WindowAutoOperationは、Windowsで動作するGUI操作の自動化スクリプトです。  
毎回実施するルーチン作業を自動化するために作成しました。

## スクリプトと使い方

* **WindowAutoOperation.bat**  
operation.txtに書いた操作命令を実行します。  
ダブルクリックで実行します。

* **GetMousePoint.bat**  
マウスカーソルの位置を取得します。  
ダブルクリックで実行します。

* **GetWindowRects.bat**  
実行中のアプリケーションのウィンドウ位置(X,Y)とサイズ(W,H)を取得します。  
ダブルクリックで実行します。

## operation.txtの例
```
# ブラウザ(IE)で名古屋を検索する
OpenURL "C:\Program Files\internet explorer\iexplore.exe" "https://www.google.co.jp/"
WaitSec 1
MoveWindow "Google - Internet Explorer" 0 0 1369 735
WaitSec 1
SendString "名古屋"
WaitSec 1
SendKey "{ENTER}"
```
## 操作命令一覧と使い方

* **OpenURL**  
指定ブラウザで指定URLに接続する。  
```
OpenURL [ブラウザのパス] [URL]
OpenURL "C:\Program Files\internet explorer\iexplore.exe" "https://www.google.co.jp/"
```
* **RunApp**  
指定アプリケーションを起動する。  
```
RunApp [アプリケーションのパス]
RunApp "C:\Program Files\internet explorer\iexplore.exe"
RunApp "notepad"
```
* **WaitSec**  
指定時間(秒)待つ。  
```
WaitSec [時間(秒)]
WaitSec 3
```

* **SendKey**  
指定キーを打ち込む。  
```
SendKey [キー]
SendKey "a" // aを打ち込む
SendKey "^c"　// Ctrl + cを打ち込む
SendKey "{ENTER}"　// Enterキーを打ち込む
```
[入力キーの詳細はこちら](https://msdn.microsoft.com/ja-jp/library/cc364423.aspx?f=255&MSPPError=-2147217396)

* **SendString**  
指定文字列を打ち込む。  
```
SendString [文字列]
SendString "東京"
```

* **ClickPoint**  
指定位置をクリックする。  
```
ClickPoint [X] [Y]
ClickPoint 200 300
```

* **ActivateWindow**  
指定ウィンドウをアクティブにする。  
```
ActivateWindow [Windowタイトル]
ActivateWindow "名古屋 - Google 検索 - Internet Explorer"
```

* **MoveWindow**  
指定ウィンドウを指定位置(X,Y)に動かして、指定サイズ(W,H)に変更する。  
```
MoveWindow [Windowタイトル] [X] [Y] [W] [H]
MoveWindow "Google - Internet Explorer" 0 0 1369 735
```
