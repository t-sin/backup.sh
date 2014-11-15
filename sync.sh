#!/bin/bash

## 引数のディレクトリを同期する
## 同期がちゃんとできたかは verify.sh でやってね
## 環境変数 tmp_dir を設定しておくこと(ロックファイルとか置く)

# 使い方
# **SRCの最後にスラッシュを付けるかどうかで結果が変わる**
# **rsyncのマニュアルを読むこと**
usage="usage: sync.sh SRC COPY [LOGFILE(abs-path ends with slash)]"

lock=${tmp_dir}/sync_sh.lock


if [ $# -lt 2 ]; then
  echo ${usage}

else
  src=$1
  dest=$2
  logfile=$3

  if [ -e ${lock} ]; then
    echo "**$0 is already running." |tee -a ${logfile}

  else
    touch ${lock}

    echo "**rsync directories." |tee -a ${logfile}
    echo "src-dir: ${src}" |tee -a ${logfile}
    echo "dest-dir: ${dest}" |tee -a ${logfile}
    echo "" |tee -a ${logfile}

    # 同期
    rsync -ah --inplace --delete --stats ${src} ${dest} 2>&1 |tee -a ${logfile} >/dev/null
    ret=${PIPESTATUS[0]}

    echo "" |tee -a ${logfile} >/dev/null

    # 実行結果チェック
    if [ ${ret} -eq 0 ]; then
      echo "**$0 is normaly finished." |tee -a ${logfile} >/dev/null
    else
      echo "**some errors occured. see the logs: ${logfile}" |tee -a ${logfile} >/dev/null
    fi
    echo ""

    rm ${lock}

    exit ${ret}
  fi
fi



