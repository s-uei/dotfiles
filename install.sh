#!/bin/bash

if [[ -z "$OPENAI_API_KEY" ]]; then
  echo "Set OPENAI_API_KEY." >&2
  exit 1
fi

# Install libatomic1 for nodejs on Linux
if [[ "$OSTYPE" != "darwin"* ]]; then
  sudo apt update -y
  sudo apt install -y libatomic1 build-essential
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
$BREWBIN/brew install gh zellij node git zsh helix uv rust

# Npm install
$BREWBIN/npm install -g opencommit

# Aider
$BREWBIN/uv tool install --force --python python3.12 --with pip aider-chat@latest

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
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
EOF
echo "export OPENAI_API_KEY=${OPENAI_API_KEY}" >>$HOME/.zshrc
echo "eval \"\$($BREWBIN/brew shellenv zsh)\"" >>$HOME/.zshrc

# Install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
  $BREWBIN/git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

# Aider config
cat >"$HOME/.aider.conf.yml" <<'EOF'
model: o4-mini
auto-commit: false
EOF

