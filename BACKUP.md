# バックアップ

## 前提条件など

* 全てのディスクをマウントする必要がある
  * `automount.sh/autoumount.sh`を`lightdm.conf`に書く
  * ntfsはrootじゃないとmount/umountできないでござる……
* `rsync`と`shasum`必須
  * あと`bash`も

## スクリプト

Windowsでは以下のことするスクリプト必要

* batからbashを起動する(タスクスケジューラで実行する用)
* backup.shを起動するのに必要な環境変数を設定する

書いてみたけど、Windowsで実行することはなさそう……


### sync.sh

フォルダの同期を行うスクリプト

### verify.sh

同期後のチェックを行うスクリプト

### backup.conf

バックアップ対象・先のペアを書いとくファイル


## スケジューリング

週に一回とかで、crontabで。
`gnome-terminal -e backup.sh`で、別窓開くとよさげ


### 書き換えなければならぬファイル

* backup.conf
  * ログの出力先`${log}`: お好きな場所に
  * バックアップ対象 `${src}`, バックアップ先`${dest}`
    * srcとdestの要素数は同じでなければならない
    * srcは、フォルダ名の末尾にスラッシュが必要
      * `rsync`のマニュアル読め
* backup-win.bat
  * **Windowsのみ**
  * bashの場所 `%BASH_CMD%`

### お好みで書き換えるファイル

* verify.conf
  * チェックサムコマンド
  * ただ、verify.shでオプション指定してるので、アルゴリズムを変えるくらいしか変更できない

## Windowsでの実行

MSYSを入れて、その中のbashで実行

=>具体的な方法を書く

* 必要なコマンド
  * rsync
  * shasum
