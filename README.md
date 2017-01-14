# dotfiles
Author: takuzoo  
Date: 12/Jan/2017  

my configuration files
- .vimrc
- .gitconfig
- .config/
  - nvim/
  - tmux
  - fonts/


### setup
```bash  
$ mkdir $HOME/.dotfiles
$ git clone https://github.com/takuzoo3868/dotfiles $HOME/.dotfiles
$ sh ./setup.sh
```

#### Tips

- nvim_install
```bash
$ sudo apt-get install software-properties-common
$ sudo add-apt-repository ppa:neovim-ppa/unstable
$ sudo apt-get update
$ sudo apt-get install neovim
$ sudo apt-get install python-dev python-pip python3-dev python3-pip
$ sudo pip2 install --user --upgrade neovim
$ sudo pip3 install --user --upgrade neovim
```
