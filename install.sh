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
auto-commits: false
EOF

# OpenCommit
cat >"$HOME/.opencommit" << 'EOF'
OCO_ONE_LINE_COMMIT=true
OCO_MODEL=gpt-4o-mini
OCO_API_URL=undefined
OCO_PROXY=undefined
OCO_API_CUSTOM_HEADERS=undefined
OCO_AI_PROVIDER=openai
OCO_TOKENS_MAX_INPUT=4096
OCO_TOKENS_MAX_OUTPUT=500
OCO_DESCRIPTION=false
OCO_EMOJI=false
OCO_LANGUAGE=en
OCO_MESSAGE_TEMPLATE_PLACEHOLDER=$msg
OCO_PROMPT_MODULE=conventional-commit
OCO_TEST_MOCK_TYPE=commit-message
OCO_OMIT_SCOPE=false
OCO_GITPUSH=true
OCO_WHY=false
OCO_HOOK_AUTO_UNCOMMENT=false
EOF
echo "OCO_API_KEY=${OPENAI_API_KEY}" >>$HOME/.opencommit

