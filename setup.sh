#!/bin/bash

# ホームディレクトリのドットファイルを置き換える
if [ ! -d "$DOTFILES_DIR" ]; then
  DOTFILES_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]:-$0}")/" && pwd)"
fi
backupDir="$HOME/dotfiles-backup-`date +%Y%m%dT%H%M%S`"

echo -e "dotfiles directory is \x1b[36m${DOTFILES_DIR}\x1b[0m"
find $DOTFILES_DIR -mindepth 1 -maxdepth 1 -name '.*' \
| grep -v 'dotfiles/.git$' \
| while read src; do
  echo ${src##*/}
  dest="$HOME/${src##*/}"
  if [ -e "$dest" -a ! "$src" -ef "$dest" ]; then
    mkdir -p "$backupDir"
    mv "$dest" "$backupDir/${src##*/}"
  fi
  ln -sfn "$src" "$dest"
done
if [ -d "$backupDir" ]; then
  echo -e "Old dotfiles has been moved to \x1b[36m${backupDir}\x1b[0m"
fi
