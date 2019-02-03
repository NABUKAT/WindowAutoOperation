$scriptpath = Split-Path -Parent $MyInvocation.MyCommand.Path
import-module $scriptpath\GUIOperation.psm1

Get-WindowRect