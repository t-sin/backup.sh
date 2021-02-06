#!/bin/bash
# データコピー後のベリファイ
## 環境変数 tmp_dir を設定しておくこと(ロックファイルとか置く)

# 使い方
usage_exit() {
    echo "usage: verify.sh [-l LOGFILE] src dest listfile"
    echo "verify in-filelist files between directories src and dest"
    echo "  -l  logs are written into LOGFILE"
    exit 1
}

# このスクリプトが存在するディレクトリ
dir=`dirname $0`
# 設定の読み込み
source ${dir}/verify.conf


# 多重機動防止用ファイル
lock=${tmp_dir}/verify_sh.lock


if [ $# -lt 3 ]; then
  usage_exit

else
  logfile=/dev/null

  while getopts l:h OPT
  do
      case $OPT in
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
  listfile=$3

  if [ -e ${lock} ]; then
    echo "**$0 is already running." |tee -a ${logfile}

  else
    touch ${lock}

    # ヘッダ出力
    echo "**verifing directories." |tee -a ${logfile}
    echo "src-dir: ${src}" |tee -a ${logfile}
    echo "dest-dir: ${dest}" |tee -a ${logfile}
    echo "" |tee -a ${logfile}

    # コピー元チェックサムを計算
    echo "*calculating check sums" |tee -a ${logfile}
    echo "" |tee -a ${logfile}
    cat /dev/null > ${checksum}
    pushd ${src} >/dev/null 2>&1
    while read LINE; do
        if [ -f "${LINE}" ]; then
            ${checksum_cmd} "${LINE}" >> ${checksum}
        fi
    done < ${listfile}
    popd >/dev/null 2>&1
    #find . -type f -exec ${checksum_cmd} {} \; > ${checksum}

    # コピー元とコピー先のチェックサムを比較
    echo "*check sums between sources and targets" |tee -a ${logfile}
    echo "" |tee -a ${logfile}
    ret=0
    if [ -s ${checksum} ]; then
        pushd ${dest} >/dev/null 2>&1
        ${checksum_cmd} --warn --check ${checksum} 2>&1 \
            |grep -v -e "OK$" - |tee -a ${logfile} >/dev/null
        ret=${PIPESTATUS[0]}
        popd >/dev/null 2>&1
    else
        echo "  no files verifying." | tee -a ${logfile}
    fi

    echo "" |tee -a ${logfile}

    # 実行結果チェック
    if [ ${ret} -eq 0 ]; then
      echo "**$0 is normaly finished." |tee -a ${logfile}
    else
      echo "**some errors occured. see the logs: ${logfile}" |tee -a ${logfile}
    fi
    echo ""

    #rm ${checksum}
    rm ${lock}

    exit ${ret}
  fi
fi



