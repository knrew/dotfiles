# dotfiles
## インストール
ホームディレクトリにdotfiles内のファイルのシンボリックリンクを作成する(例: `dotfiles/.config/i3/config -> ~/.config/i3/config`)．

次のファイルはインストールされない．
- `dotfiles/.git`
- `dotfiles/.gitignore`
- `dotfiles/README.md`
- `dotfiles/ex/`以下に置かれたファイル
    - インストールしないファイルは`ex`以下に置くようにする．

[dotfiles-manager](https://github.com/knrew/dotfiles-manager)を用いる．
あらかじめRustをインストールしておく．

```sh
cd ~
git clone https://github.com/knrew/dotfiles.git .dotfiles 
~/.dotfiles/ex/install.sh
```
