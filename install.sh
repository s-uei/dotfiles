#!/bin/bash

# Install libatomic1 for nodejs on Linux
if [[ "$OSTYPE" != "darwin"* ]]; then
  sudo apt update -y
  sudo apt install -y libatomic1
fi

# Set excutable brew path
if [[ "$OSTYPE" == "darwin"* ]]; then
  BREWBIN="/opt/homebrew/bin"
else
  BREWBIN="/home/linuxbrew/.linuxbrew/bin"
fi

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Brew install
$BREWBIN/brew install gh zellij node git zsh neovim

# Npm install
$BREWBIN/npm install -g opencommit

# Set default shell as zsh
if ! grep -qx "$BREWBIN/zsh" /etc/shells; then
  echo $BREWBIN/zsh | sudo tee -a /etc/shells
fi
if [ $SHELL != $BREWBIN/zsh ]; then
  sudo chsh -s $BREWBIN/zsh $USER
fi

# Edit zshrc
cat >"$HOME/.zshrc" <<'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
EOF
echo "eval \"\$($BREWBIN/brew shellenv zsh)\"" >>$HOME/.zshrc

# Install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
  $BREWBIN/git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

# Add symbolic link of nvim config
mkdir -p ~/.config
ln -sfn .config/nvim ~/.config/nvim
