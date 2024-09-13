# dotfiles
## インストール
dotfiles以下のファイルのシンボリックリンクを作成する．

次のファイルはインストールされない．
- `/.git`
- `/.gitignore`
- `/README.md`
- `/ex/`以下のファイル

[dotfiles_manager](https://github.com/knrew/dotfiles_manager)を用いる．
あらかじめRustをインストールする．

```sh
cd ~
git clone https://github.com/knrew/dotfiles.git .dotfiles 
sh ~/.dotfiles/ex/install.sh
```
