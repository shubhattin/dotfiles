alias cls=clear
alias expl="explorer.exe ."
alias ipy=ipython
alias rm="rm -i"
alias yay=paru

# Neovim
if [ -d /opt/nvim-linux64/bin ]; then
  export PATH="$PATH:/opt/nvim-linux64/bin"
fi

if [ -d ~/.local/bin ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Python
# alias py='python3'
# Prefer adding the following to ~/.zshrc
# in the plugins and python, vscode

# Java
export JAVA_HOME="/usr/lib/jvm/default"

# NVM
if [ -d /usr/share/nvm ]; then
  source /usr/share/nvm/init-nvm.sh
fi

# bun
if [ -d ~/.bun ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH=$BUN_INSTALL/bin:$PATH
  # bun completions
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi

# deno
if [ -d ~/.deno ]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# Rust
if [ -d ~/.cargo/bin ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -f ~/.cargo/env ]; then
  . "$HOME/.cargo/env"
fi

# Julia
# if [ -d ~/.julia/bin ]; then
# 	export PATH="$HOME/.julia/bin:$PATH"
# fi

# SDKMan
if [ -f ~/.sdkman/bin/sdkman-init.sh ]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Go
if [ -d /usr/local/go ]; then
  export PATH=$PATH:/usr/local/go/bin
fi
if [ -d ~/go ]; then
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH/bin
fi
