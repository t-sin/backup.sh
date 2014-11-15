#!/bin/bash

## 引数のディレクトリを同期する
## 同期がちゃんとできたかは verify.sh でやってね
## 環境変数 tmp_dir を設定しておくこと(ロックファイルとか置く)

# 使い方
# **SRCの最後にスラッシュを付けるかどうかで結果が変わる**
# **rsyncのマニュアルを読むこと**
usage_exit() {
    echo "usage: sync.sh [-l LOGFILE] [-f LISTFILE] src(ends with slash)] dest"
    echo "  -l LOGFILE   logs are written into LOGFILE"
    echo "  -f LISTFILE  list of files transferred are written into LISTFILE"
    exit 1
}

lock=${tmp_dir}/sync_sh.lock


if [ $# -lt 2 ]; then
  usage_exit

else

  logfile=/dev/null
  listfile=/dev/null

  while getopts f:l:h OPT
  do
      case $OPT in
          f)  listfile=$OPTARG
              ;;
          l)  logfile=$OPTARG
              ;;
          h)  usage_exit
              ;;
          \?) usage_exit
              ;;
      esac
  done
  shift $((OPTIND - 1))
  
  src=$1
  dest=$2

  if [ -e ${lock} ]; then
    echo "**$0 is already running." |tee -a ${logfile}

  else
    touch ${lock}

    echo "**rsync directories." |tee -a ${logfile}
    echo "src-dir: ${src}" |tee -a ${logfile}
    echo "dest-dir: ${dest}" |tee -a ${logfile}
    echo "" |tee -a ${logfile}

    # 同期
    rsync -aih --inplace --delete --out-format='%n%L' \
        --log-file=${logfile} --log-file-format=''\
        ${src} ${dest} 1>${listfile}
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



