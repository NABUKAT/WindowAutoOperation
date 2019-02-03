$scriptpath = Split-Path -Parent $MyInvocation.MyCommand.Path
import-module $scriptpath\GUIOperation.psm1
$input = Read-Host "座標を取得したい位置にマウスカーソルを移動させてEnterキーを押してください。"
if($input -eq ""){
    Write-Host("マウスカーソルの座標(X Y)：　" + [GUIOperation]::GetCursorPosition())
}