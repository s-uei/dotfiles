#!/bin/bash

if [[ -z "$OPENAI_API_KEY" ]]; then
  echo "Set OPENAI_API_KEY." >&2
  exit 1
fi

# Set excutable brew path
if [[ "$OSTYPE" == "darwin"* ]]; then
  BREWBIN="/opt/homebrew/bin"
else
  BREWBIN="/home/linuxbrew/.linuxbrew/bin"
fi

PATH="$BREWBIN:$PATH"

# Install Homebrew
which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Brew install
which gh || brew install gh
which zellij || brew install zellij
which node || brew install node
which zsh || brew install zsh
which hx || brew install helix
which gh || brew install gh
which cargo || brew install rust
which copilot || brew install copilot-cli

# Npm install
which oco || npm install -g opencommit
which prettier || npm install -g prettier

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

# OpenCommit
$BREWBIN/oco config set OCO_API_KEY=$OPENAI_API_KEY

