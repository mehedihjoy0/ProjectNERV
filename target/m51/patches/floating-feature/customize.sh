#!/usr/bin/env bash
set -e

# ─── YOUR BLOBS ──────────────────────────────────────────────────────────────
BLOBS="
system/etc/floating_feature.xml
"

add(){
  p=$1;o=$2;u=0;g=0
  # remap system_ext
  if [[ $p==system_ext ]];then
    if $TARGET_HAS_SYSTEM_EXT;then f=system_ext/$o; else p=system;f=system/system/system_ext/$o;fi
  else f=$p/$o;fi

  # mode
  [[ ${o##*/}==*.* ]]&&m=644||m=755

  # selinux context
  case "${p}/${o}" in
    */lib/*|*/lib64/*)        c=u:object_r:system_lib_file:s0;;
    system/app/*|*/priv-app/*) c=u:object_r:system_app_file:s0;;
    */bin/*)                  c=u:object_r:system_exec_file:s0;;
    */etc/*|*/framework/*)    c=u:object_r:system_file:s0;;
    product/lib*|product/lib64*) c=u:object_r:product_lib_file:s0;;
    product/*)                c=u:object_r:product_file:s0;;
    *)                        c=u:object_r:system_file:s0;;
  esac

  # fs_config
  t=$f; [[ $p==system ]]&&t=${t#system\/system\/}; cfg=$WORK_DIR/configs/fs_config-$p
  while [[ $t!=. ]];do
    if ! grep -q "^$t " $cfg;then
      if [[ $t==$f ]];then
        echo "$t $u $g $m capabilities=0x0">>$cfg
      else
        echo "$t 0 $([[ $p==vendor ]]&&echo 2000||echo 0) 755 capabilities=0x0">>$cfg
      fi
    else break;fi
    t=${t%/*}
  done

  # file_context
  t=${f//./\\.}; [[ $p==system ]]&&t=${t#system\/system\/}; fc=$WORK_DIR/configs/file_context-$p
  while [[ $t!=. ]];do
    if ! grep -q "^/$t " $fc;then echo "/$t $c">>$fc; else break;fi
    t=${t%/*}
  done
}

for b in $BLOBS;do
  p=${b%%/*}; o=${b#*/}; add "$p" "$o"
done