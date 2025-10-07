# dotfiles

個人用dotfiles．
管理は[dotkoke](https://github.com/knrew/dotkoke)を通じて行われる．

## 構成

$HOME以下(の管理対象となるファイル)を`dotfiles/home/`以下に再現する(例: `~/.zshrc`->`dotfiles/home/.zshrc`)．
$HOME側にはシンボリックリンクのみを置き，実体は`dotfiles/home/`に置く．

## セットアップ手順

[dotkoke](https://github.com/knrew/dotkoke)をインストールする．

dotfilesをクローンする．
```sh
git clone git@github.com:knrew/dotfiles.git .dotfiles
```

既存ファイルのバックアップ用ディレクトリを作成する．
```sh
mkdir -p ~/.backup_dotfiles/
```

`dotkoke_config.toml`を複製し，環境に合わせて編集する．
```sh
cp ~/.dotfiles/home/.config/dotkoke/dotkoke_config_template.toml \
   ~/.dotfiles/home/.config/dotkoke/dotkoke_config.toml
```

インストールする．`dotfiles/home`以下のファイルが$HOMEに展開される．
```sh
dotkoke install
```

## 運用ルール

- 新しいファイルの作成は，`.dotfiles/home/`以下で行う．$HOME以下に直接ファイル作成は行わない．ファイルを作成した場合，`dotkoke install`により展開する．
  - 直接作成した場合や，あとから管理対象に加えることになったファイルは`dotkoke add <PATH>`コマンドによって行う．
- (管理対象の)ファイルの削除には`dotkoke remove <PATH>`によって行う．`rm`コマンドを使った直接的な削除は行わないこと．
- 管理対象のファイルは`dotfiles/home/`以下のみ．その外側にファイルを置くこともできるが，$HOMEには展開されない．
