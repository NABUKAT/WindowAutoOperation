$scriptpath = Split-Path -Parent $MyInvocation.MyCommand.Path
import-module $scriptpath\GUIOperation.psm1

function MoveWindow($title, $x, $y, $w, $h){
    Move-WindowRect $title $x $y $w $h
}
#MoveWindow "files" -2000 13 1310 1027

function OpenURL($browserpath, $url){
    start $browserpath $url
}
#OpenURL "C:\Program Files\internet explorer\iexplore.exe" "https://www.google.co.jp/"

function WaitSec($sec){
    Start-Sleep -s $sec
}

function SendKey($key){
    [GUIOperation]::SendKey($key)
}

function SendString($str){
    $outputencoding=[console]::outputencoding
    $str | Clip
    SendKey("^v")
}

function ClickPoint($x, $y){
    [GUIOperation]::LeftClick($x, $y)
}

function ActivateWindow($title){
    [GUIOperation]::ActivateWindow($title)
}

$oppath = Split-Path -Parent $scriptpath
$fileName = $oppath + "\operation.txt"
$file = New-Object System.IO.StreamReader($fileName, [System.Text.Encoding]::GetEncoding("sjis"))
while (($line = $file.ReadLine()) -ne $null)
{
    Invoke-Expression $line
}