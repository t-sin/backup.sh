#!/bin/bash
# データコピー後のベリファイ
## 環境変数 tmp_dir を設定しておくこと(ロックファイルとか置く)

# 使い方
usage="usage: verify.sh COPY-SRC COPY-DEST [LOGFILE(abs-path ends with slash)]"

# このスクリプトが存在するディレクトリ
dir=`dirname $0`
# 設定の読み込み
source ${dir}/verify.conf


# 多重機動防止用ファイル
lock=${tmp_dir}/verify_sh.lock


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

    # ヘッダ出力
    echo "**verifing directories." |tee -a ${logfile}
    echo "src-dir: ${src}" |tee -a ${logfile}
    echo "dest-dir: ${dest}" |tee -a ${logfile}
    echo "" |tee -a ${logfile}

    # コピー元チェックサムを計算
    pushd ${src} >/dev/null 2>&1
    find . -type f -exec ${checksum_cmd} {} \; > ${checksum}
    popd >/dev/null 2>&1

    # コピー元とコピー先のチェックサムを比較
    pushd ${dest} >/dev/null 2>&1
    ${checksum_cmd} --warn --check ${checksum} 2>&1 \
      |grep -v -e "OK$" - |tee -a ${logfile} >/dev/null
    ret=${PIPESTATUS[0]}
    popd >/dev/null 2>&1

    echo "" |tee -a ${logfile} >/dev/null

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



