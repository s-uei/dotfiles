#!/bin/bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Set excutable brew path
if [[ "$OSTYPE" == "darwin"* ]]; then
  BREWBIN="/opt/homebrew/bin"
else
  sudo apt update -y
  sudo apt install -y libatomic1
  BREWBIN="/home/linuxbrew/.linuxbrew/bin"
fi

# Brew install
$BREWBIN/brew install gh zellij helix node git zsh

# Npm install
$BREWBIN/npm install -g opencommit

# Set default shell as zsh
sudo chsh -s $BREWBIN/zsh $USER

# Edit zshrc
cat > "$HOME/.zshrc" <<'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
EOF

# Install oh-my-zsh
$BREWBIN/git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
