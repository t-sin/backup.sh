#!/bin/bash
## winでバックアップするためのラッパ
## 理由：
##  -MSYSのbashでfindを実行すると、windowsのfindが実行されるため

## MSYSのbinのみパス通す
export PATH=/usr/bin


## バックアップ実行
`dirname $0`/backup.sh
