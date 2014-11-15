@echo off
REM バックアップを実行するバッチ
REM MSYS(rsync, shasum含む)環境が存在すること


REM bashの場所
set BASH_CMD=C:/MinGW/MSYS/1.0/bin/bash.exe


REM バックアップ実行
%BASH_CMD% %~dp0/backup-win.sh

