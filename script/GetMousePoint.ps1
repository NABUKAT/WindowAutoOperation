$scriptpath = Split-Path -Parent $MyInvocation.MyCommand.Path
import-module $scriptpath\GUIOperation.psm1
$input = Read-Host "���W���擾�������ʒu�Ƀ}�E�X�J�[�\�����ړ�������Enter�L�[�������Ă��������B"
if($input -eq ""){
    Write-Host("�}�E�X�J�[�\���̍��W(X Y)�F�@" + [GUIOperation]::GetCursorPosition())
}