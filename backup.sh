#!/bin/bash

## データのバックアップ
## データディスクの自動マウントをなんとかしておくこと
## => Ubuntuならgnome-disksで自動マウント設定が可能

# backup.shが存在するディレクトリ
dir=`dirname $0`
# 同期するスクリプト
sync_sh=${dir}/sync.sh
# ベリファイするスクリプト
verify_sh=${dir}/verify.sh

transferred=${tmp_dir}/sync_sh.list

# バックアップ対象読み込む (ログの出力先も)
source ${dir}/backup.conf


# バックアップ対象をうまく出力
function print_target() {
  i=0
  while [ $i -lt ${#src[*]} ]
  do
    echo "[$i] ${src[$i]}"  |tee -a ${log}
    echo " => ${dest[$i]}"  |tee -a ${log}
    i=`expr $i + 1`
  done
}

# 同期 & チェックする関数
function copy_and_verify() {
    cat /dev/null > ${transferred}
    ${sync_sh} -l ${log} -f ${transferred} $1 $2 
    if [ $? -ne 0 ]; then
        echo "** occuring errors copying $1 to $2" |tee -a ${log}
    fi

    ret=$?

    ${verify_sh} -l ${log} $1 $2 ${transferred}
    if [ $? -ne 0 ]; then
        echo "** occuring errors verifying between $1 and $2" |tee -a ${log}
    fi

    return 0
}


# ヘッダ出力
echo ";;; backup.sh" >> ${log}
echo ":date " `date` >> ${log}

echo "**backup targets..." |tee -a ${log}
print_target
echo "" |tee -a ${log}

# srcとdestの数、あってる？
error=0
if [ ${#src[*]} -ne ${#dest[*]} ]; then
  echo "**number of elements is different: \${SRC} and \${DEST}." $'\n' |tee -a ${log}
  error=1
fi



# 各バックアップ対象を同期＆チェック
i=0
while [ ${i} -lt ${#src[*]} ]
do
  if [ ${error} -eq 1 ]; then
    break
  fi

  copy_and_verify ${src[$i]} ${dest[$i]}
  ret=$?
  i=`expr $i + 1`

  if [ ${ret} -ne 0 ]; then 
    error=1
  fi
done

# エラー状態チェック
if [ ${error} -eq 0 ]; then
    echo "**backup finished. logs: ${log}." |tee -a ${log}
  else
    echo "**backup failed. check logs: ${log}." |tee -a ${log}
fi
echo ":finish-date " `date` >> ${log}

echo $'\n\n\n' >> ${log}

echo "[press Enter key]"
read Wait
exit ${error}

