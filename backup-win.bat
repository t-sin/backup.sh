@echo off
REM �o�b�N�A�b�v�����s����o�b�`
REM MSYS(rsync, shasum�܂�)�������݂��邱��


REM bash�̏ꏊ
set BASH_CMD=C:/MinGW/MSYS/1.0/bin/bash.exe


REM �o�b�N�A�b�v���s
%BASH_CMD% %~dp0/backup-win.sh

