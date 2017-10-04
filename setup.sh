#!/bin/sh

set -e
set -u

setup() {
  dotfiles=$HOME/.dotfiles

  # パッケージの存在確認
  has() {
    type "$1" > /dev/null 2>&1
  }

  # シンボリックリンク作成
  symlink() {
    [ -e "$2" ] || ln -sf "$1" "$2"
  }

  # パッケージのインストール
  install_package() {
    if [ -e /etc/arch-release ]; then
      yaourt -S $* 
    elif [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
      sudo apt install $*
    fi
  }
  
  # 非公式リポジトリの追加
  add_repository() {
    if [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
      sudo add-apt-repository $*
    fi
  }
  
  # パッケージの更新
  update_repository() {
    if [ -e /etc/arch-release ]; then
      yaourt -Syua 
    elif [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
      sudo apt update
    fi
  }
  
  # Pythonモジュールのインストール
  install_python() {
    sudo pip install $*
  }
  
  dotfiles_logo='
   ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
 ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
 ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
 ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
 ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
 ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
                                                              
  *** WHAT IS INSIDE? ***
  1. Download https://github.com/takuzoo3868/dotfiles.git
  2. Symlinking dot files to your home directory
  
  See the README for documentation.
  https://github.com/takuzoo3868/dotfiles
  Licensed under the MIT license.
'

  # dotfilesのセットアップ
  echo "$dotfiles_logo"
  if [ ! -d "$dotfiles" ]; then
    echo "Installing dotfiles for the first time"
    git clone git@github.com:takuzoo3868/dotfiles.git "$dotfiles"
  else
    echo "dofiles is already installed"
  fi

  # Bashのセットアップ
  echo ">>> bash"
  symlink "$dotfiles/.bashrc" "$HOME/.bashrc"
  /bin/echo -e "<<< [\e[1;32m ok \e[m] "

  # Gitのセットアップ
  echo ">>> git"
  if ! has git; then
    install_package git || echo "Failed to install git"
  fi
  symlink "$dotfiles/.gitconfig" "$HOME/.gitconfig"
  symlink "$dotfiles/.gitignore_global" "$HOME/.gitignore_global"
  symlink "$dotfiles/.gitmessage" "$HOME/.gitmessage"
  mkdir -p $HOME/.git_template/hooks
  /bin/echo -e "<<< [\e[1;32m ok \e[m] "


  # Vimのセットアップ
  echo ">>> neovim & vim"
  if ! has vim; then
    install_package vim || echo "Failed to install vim"
  fi
  symlink "$dotfiles/.vimrc" "$HOME/.vimrc"

  # Neovimのセットアップ
  if ! has nvim; then
    if  [ -e /etc/arch-release ]; then
      install_package python2-neovim python-neovim
      install_package neovim
    elif [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
      install_package software-properties-common
      add_repository ppa:neovim-ppa/unstable
      update_repository
      install_package python-dev python-pip python3-dev python3-pip
      install_package neovim
      install_package xclip xsel
    fi
  fi
  #sudo pip2 install --upgrade neovim
  #sudo pip3 install --upgrade neovim
  symlink "$dotfiles/.config/nvim" "$HOME/.config/nvim"
  /bin/echo -e "<<< [\e[1;32m ok \e[m] "

  # Nyaovimのセットアップ
  echo ">>> nyaovim"
  symlink "$dotfiles/.config/nyaovim" "$HOME/.config/nyaovim"
  /bin/echo -e "<<< [\e[1;32m ok \e[m] "
  
  # Tmuxのセットアップ
  echo ">>> tmux"
  if ! has tmux; then
    install_package tmux || echo "Failed to install tmux"
  fi
  symlink "$dotfiles/.config/tmux/.tmux.conf" "$HOME/.tmux.conf"
  /bin/echo -e "<<< [\e[1;32m ok \e[m] "

  # Powerlineのセットアップ
  echo ">>> powerline"
  if ! has powerline; then
    install_python --user git+git://github.com/powerline/powerline
    install_python psutil
  fi
  symlink "$dotfiles/.config/powerline" "$HOME/.config/powerline"
  /bin/echo -e "<<< [\e[1;32m ok \e[m] "

}
setup
